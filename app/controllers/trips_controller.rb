class TripsController < ApplicationController
  include CommonRender
  
  before_action :authenticate_request,
    only: [:create, :update, :destroy, :like, :delete_comment, :add_comment]
  before_action :set_trip, only: [:show, :update, :destroy, :like, :increase_view_count]
  before_action :sanitise_params, only: [:create, :update]


  # GET /trips
  def index
    offset = ((params[:page] || 1).to_i - 1) * 6
    @trips =
      Trip
      .includes(:user, places: :pictures)
      .where.not(user_id: current_user.try(:id),
                 approved: false)
      .order(created_at: :desc)
      .limit(6)
      .offset(offset)

    total_pages = find_total_pages
    render json: {trips: custom_serializer(@trips, TripSerializer), total_pages: total_pages}
  end

  # GET /trips/1
  def show
    # count
    render json: @trip
  end

  # POST /trips
  def create
    @trip = current_user.trips.new(trip_params)
    if @trip.save
      render json: @trip, status: :created, location: @trip
    else
      render json: @trip.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /trips/1
  def update
    if @trip.update(trip_params)
      # binding.pry
      render json: @trip
    else
      render json: @trip.errors, status: :unprocessable_entity
    end
  end

  # DELETE /trips/1
  def destroy
    @trip.destroy
  end
  
  # GET /users/:user_id/trips
  def get_user_trips
    user = User.find(params[:user_id])
    trips =
      user
      .trips
      .includes(places: :pictures)
      .order(created_at: :desc)
      .offset(params[:page])
      .limit(10)

    render json: trips
  end

  # POST /trips/search
  def search
    page = (params[:page] || 1).to_i - 1
    @trips =
      Trip
      .includes(:user, places: :pictures)
      .where.not(user_id: current_user.try(:id), 
                 approved: false
        )
      .tagged_with(params[:keywords].try(:split), any: true)
      .order(created_at: :desc)
      .offset(page)
      .limit(10)
    
    render json: @trips
  end  

  # POST /trips/like
  def like
    @trip.toggle_like(current_user)
    render json: @trip
  end

  # GET /trips/trending
  def trending
    offset = ((params[:page] || 1).to_i - 1) * 6
    @trips =
      Trip
      .includes(:user, places: :pictures)
      .where.not(user_id: current_user.try(:id),
        approved: false
        )
      .order(cached_weighted_average: :desc)
      .limit(6)
      .offset(offset)

    total_pages = find_total_pages
    render json: {trips: custom_serializer(@trips, TripSerializer), total_pages: total_pages}
  end

  # GET /trips/:id/comments
  def comments
    comments =
      HTTParty
      .get("#{ENV["YT_COMMENT_API_URL"]}/trips/#{params[:id]}/comments")
      .as_json["data"]

    users = User.where(id: comments.map{|comm| comm["user_id"]})
    users = custom_serializer(users, UserSerializer).as_json

    comments = comments.map! do |comment|
      comment.merge(user: users.find{|user| user[:id] == comment["user_id"].to_i})
    end


    render json: comments
  end

  # POST /trips/comments/:id
  def delete_comment
    if params[:user_id] == current_user.id.to_s
      HTTParty.delete("#{ENV["YT_COMMENT_API_URL"]}/comments/#{params[:id]}")
    else
      render json: "ERROR", status: :unauthorized 
    end
  end

  # POST /trips/comments
  def add_comment
    if comment_params[:user_id] == current_user.id

      comment =
        HTTParty
        .post(
          "#{ENV["YT_COMMENT_API_URL"]}/comments",
          body: {
            comment: comment_params.as_json
        }).as_json["data"]
      
      comment["user"] = custom_serializer([User.find(current_user.id)], UserSerializer).as_json[0]
      broadcast(comment)
      render json: comment
    else
      render json: "ERROR", status: :unauthorized 
    end
  end

  # POST /trips/increase_view_count
  def increase_view_count
    # can also be written as
    # impressionist(trip, nil, unique: [:ip_address, user_id, etc])

    impressionist(@trip)
    render_success("success")
  end

  # POST /graph_data_for_trip
  # Params => {id: some_trip_id}
  def graph_data_for_trip
    @trip_view_stats = TripViewStats.new(id: params[:id])
    result = @trip_view_stats.call

    if result[:status]
      render_success(result)
    else
      render_error(result[:error])
    end
  end

  private

  # find total pages in pagination
  def find_total_pages
    trips = Trip.all.count
    totol_pages = (trips/6.0).ceil 
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_trip
    @trip = Trip.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def trip_params
    params.require(:trip).permit(:id, :name, :description, :status, :start_date, :end_date, :tag_list => [], 
      places_attributes: [:id, :name, :description, :review, :visited_date, :_destroy,
        pictures_attributes: [:id, :user_id, :description, :url, :public_id, :_destroy]
      ]
    )
  end

  def sanitise_params
    params['trip']['places_attributes'] = params['trip']['places']
      params['trip']['places_attributes'].each do |place|
      # Change for picture here
      place['pictures_attributes'] = place['pictures']
    end
  end

  def comment_params
    params.require(:comment).permit(:user_id, :trip_id, :message)
  end

  def broadcast(comment)
    ActionCable.server.broadcast('comments', comment.as_json.merge(action: 'CreateComments'))
  end
end
