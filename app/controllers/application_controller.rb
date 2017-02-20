class ApplicationController < ActionController::Base
  include Authenticable
  include Common  
  # before_action :set_current_user
  # protect_from_forgery with: :null_session
  before_action :authenticate_api
  # This authentication should be at the controller level
  before_action :set_raven_context

  # This authentication should be at the controller level
  attr_reader :current_user 
  
  private

  def authenticate_api
    # Dirty checking for admin user.
    # TODO: Need to correctly implement this
    # issue: Devise not sending user auth details in headers instead it sends in params
    # our code is implemented to check headers. hence the whole if else hack below
    if params[:user].try(:[], :email) == "admin@example.com"
      # return admin user
      # TODO: must check for auth token and other stuff to decode 
      # the token and find user
      @current_user = User.find_by(email: "admin@example.com")
    else
      @current_user = AuthorizeApiRequest.call(request.headers).result
      Thread.current[:current_user] = @current_user
    end
  end

  def user_signed_in?
    current_user.present?
  end
  
  # def authenticate_user!
  #   unauthorized! unless current_user
  # end
  
  # def unauthorized!
  #   head :unauthorized
  # end

  # def current_user
  #   @current_user
  # end

  # def set_current_user
  #   # binding.pry
  #   token = request.headers['Authorization'].to_s.split(' ').last
  #   # token = params['Authorization'].try(:last)
  #   return unless token
  #   payload = Token.new(token)

  #   @current_user = User.find(payload.user_id) if payload.valid?
  # end


  # For storing parms and session only in 
  # production and staging envionment
  def set_raven_context
    Raven.user_context(id: session[:current_user_id]) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
