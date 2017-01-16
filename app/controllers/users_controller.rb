class UsersController < ApplicationController
  before_action :authenticate_request, only: [:show, :update_user_profile_media, :add_traveller_to_user_following_list]

  # create new user
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def show 
    if current_user
      render json: {user: current_user}, status: :ok
    else
      render json: {message: "User not present"}, status: :not_found
    end
  end

  def get_user_by_id
    id = params[:user_id]
    user = User.find(id)
    if user 
      render json: {user: user}, status: :ok
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
    render json: {user: current_user, status: status}
  end

  def add_traveller_to_user_following_list
    user = current_user
    user.active_relationships.create(followed_id: params[:followed_id])
    render json: {status: true}
  end

  def get_user_followers
    id = params[:user_id]
    user = User.find(id)
    user_followers = user.followers
    render json: {followers: user_followers}
  end

  def get_user_following
    id = params[:user_id]
    user = User.find(id)
    user_following = user.following
    render json: {following: user_following}
  end

  private

  def media_type
    params['mediaType'] == 'profile_pic' ? profile_pic : 'cover_photo' 
  end


  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
