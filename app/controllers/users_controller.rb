class UsersController < ApplicationController
  before_action :authenticate_request, only: [:show, :update_user_profile_media, 
                                              :add_traveller_to_user_following_list,
                                              :follow_trip_user, :auth_user]

  # create new user
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity 
    end
  end

  def show 
    if current_user
      render json: current_user
    else
      render json: {message: "User not present"}, status: :not_found
    end
  end

  def get_user_by_id
    id = params[:user_id]
    user = User.find(id)
    if user 
      render json: user
    else 
      render json: {message: 'User not found'}, status: :not_found
    end
  end

  def update_user_profile_media 
    user = current_user
    status = if params['mediaType'].in? %w(profile_pic cover_photo)
      user[params['mediaType']] = {url: params["url"], public_id: params["public_id"] }
      user.save
      true
    else
      false
    end
    render json: current_user
  end

  def add_traveller_to_user_following_list
    followed_id = params[:followed_id]
    current_user.toggle_follow(followed_id)
    followed_user = User.find(followed_id)
    render json: followed_user
  end

  def follow_trip_user
    id = params[:trip_id]
    trip = Trip.find(id)
    user_id = trip.user.id
    current_user.toggle_follow(user_id)
    trip = Trip.find(id)
    render json: trip
  end

  def get_user_followers
    id = params[:user_id]
    user = User.find(id)
    user_followers = user.followers
    render json: user_followers
  end

  def get_user_following
    id = params[:user_id]
    user = User.find(id)
    user_following = user.following
    render json: user_following
  end

  def auth_user
    if current_user
      render json: current_user
    else
      render json: { error: "User not present" }, status: :not_found
    end
  end

  private

  def media_type
    params['mediaType'] == 'profile_pic' ? profile_pic : 'cover_photo' 
  end


  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
