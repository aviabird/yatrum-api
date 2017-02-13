class ApplicationController < ActionController::API
  include Authenticable
  include Common  
  
  before_action :authenticate_api
  # This authentication should be at the controller level

  attr_reader :current_user 
  private

  def authenticate_api
    @current_user = AuthorizeApiRequest.call(request.headers).result
    Thread.current[:current_user] = @current_user
  end

  def user_signed_in?
    current_user.present?
  end
end
