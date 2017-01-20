class ApplicationController < ActionController::API
  include Authenticable
  include Common  
  # before_action :authenticate_request 
  # This authentication should be at the controller level

  # attr_reader :current_user 
  # private

  # def authenticate_request 
  #   @current_user = AuthorizeApiRequest.call(request.headers).result 
  #   render json: { error: 'Not Authorized' }, status: 401 unless @current_user 
  # end

  # def user_signed_in?
  #   current_user.present?
  # end
end
