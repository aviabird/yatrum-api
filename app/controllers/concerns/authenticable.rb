module Authenticable

  attr_reader :current_user 

  def authenticate_request 
    @current_user = AuthorizeApiRequest.call(request.headers).result
    Thread.current[:current_user] = @current_user
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user 
  end

  def user_signed_in?
    current_user.present?
  end
end