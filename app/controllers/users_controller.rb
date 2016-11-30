class UsersController < ApplicationController
  before_action :authenticate_request, only: [:show]

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

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
