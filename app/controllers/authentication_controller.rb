class AuthenticationController < ApplicationController
  # skip_before_action :authenticate_request
  include CommonRender

  def social_authenticate
    @oauth = "Oauth::#{params['provider'].titleize}".constantize.new(params)     
    if @oauth.authorized?
      @user = User.from_auth(@oauth.formatted_user_data, current_user)
      if @user
        serialized_user = ActiveModelSerializers::SerializableResource.new(@user, adapter: :json).as_json[:user]
        render_success( auth_token: JsonWebToken.encode(user_id: @user.id), user: serialized_user)
      else
        render_error "This #{params[:provider]} account is used already"
      end
    else
      render_error("There was an error with #{params['provider']}. please try again.")
    end
  end

  def authenticate 
    command = AuthenticateUser.call(params[:email], params[:password]) 

    if command.success? 
      user = User.find_by_email(params[:email])
      User.current = user
      user = ActiveModelSerializers::SerializableResource.new(user, adapter: :json).as_json[:user]
      render json: { auth_token: command.result, user:  user}
    else
      User.current = nil
      render json: { error: command.errors }, status: :unauthorized 
    end 
  end

  #TODO: Signout Implement it later for now only frontend implementation
end
