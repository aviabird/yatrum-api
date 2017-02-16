class ApplicationController < ActionController::API
  include Authenticable
  include Common  
  
  before_action :authenticate_api
  # This authentication should be at the controller level
  before_action :set_raven_context

  attr_reader :current_user 
  private

  def authenticate_api
    @current_user = AuthorizeApiRequest.call(request.headers).result
    Thread.current[:current_user] = @current_user
  end

  def user_signed_in?
    current_user.present?
  end


  # For storing parms and session only in 
  # production and staging envionment
  def set_raven_context
    Raven.user_context(id: session[:current_user_id]) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

end
