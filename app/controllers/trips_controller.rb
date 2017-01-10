class TripsController < ApplicationController
  before_action :authenticate_request, only: [:create, :update, :destroy]
  before_action :set_trip, only: [:show, :update, :destroy]

  # GET /trips
  def index
    @trips = Trip.includes(:user, cities: [places: :pictures])
    render json: Oj.dump(@trips.as_json)
  end

  # GET /trips/1
  def show
    render json: @trip
  end

  # POST /trips
  def create
    @trip = current_user.trips.new(trip_params)
    if @trip.save
      render json: Oj.dump(@trip.as_json), status: :created, location: @trip
    else
      render json: Oj.dump(@trip.errors.as_json), status: :unprocessable_entity
    end
  end

  # PATCH/PUT /trips/1
  def update
    if @trip.update(trip_params)
      render json: Oj.dump(@trip.as_json)
    else
      render json: Oj.dump(@trip.errors), status: :unprocessable_entity
    end
  end

  # DELETE /trips/1
  def destroy
    @trip.destroy
  end
  
  def get_user_trips
    user = User.find(params[:user_id])
    trips = user.trips.includes(cities: [places: :pictures])
    render json: Oj.dump(trips.as_json)
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
end
