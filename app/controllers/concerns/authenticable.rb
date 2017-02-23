module Authenticable

  def authenticate_request 
    render json: { error: 'Not Authorized' }, status: 401 unless user_signed_in?
  end

end