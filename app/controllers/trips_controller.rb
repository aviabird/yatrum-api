class TripsController < ApplicationController
  before_action :authenticate_request, only: [:create, :update, :destroy]
  before_action :set_trip, only: [:show, :update, :destroy]
  before_action :sanitise_params, only: [:create, :update]

  # GET /trips
  def index
    @trips =
      Trip
      .includes(:user, cities: [places: :pictures])
      .limit(10)
      .offset(params[:page] || 0)

    render json: Oj.dump(
      @trips.as_json(
        include: [
          :user,
          cities: {
            include: [
              places: {
                include: :pictures
              }
            ]
          }
        ]
      )
    )
  end

  # GET /trips/1
  def show
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
      .includes(cities: [places: :pictures])
      .order(created_at: :desc)
      .offset(params[:page])
      .limit(10)

    render json: Oj.dump(
      trips.as_json(
        include: [
          :user,
          cities: {
            include: [
              places: {
                include: :pictures
              }
            ]
          }
        ]
      )
    )
  end

  # GET /trips/search
  def search
    @trips =
      Trip
      .includes(:user, cities: [ places: :pictures ])
      .tagged_with(params[:keywords].try(:split), any: true)
      .order(created_at: :desc)
      .offset(params[:page])
      .limit(10)

    render json: Oj.dump(
      @trips.as_json(
        include: [
          :user,
          cities: {
            include: [
              places: {
                include: :pictures
              }
            ]
          }
        ]
      )
    )
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_trip
    @trip = Trip.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def trip_params

    params.require(:trip).permit(:id, :name, :description, :status, :start_date, :end_date,
      cities_attributes: [:id, :name, :country, 
        places_attributes: [:id, :name, :description, :review]
      ]
    )
  end

  def sanitise_params
    params['trip']['cities_attributes'] = params['trip']['cities']
    # params['trip'].delete('cities')
    params['trip']["cities_attributes"].each do |city|
      city['places_attributes'] = city['places']
      # city.delete('places')
      city.values_at('places_attributes').each do |place|
        # Change for picture here
      end
    end
  end
end
