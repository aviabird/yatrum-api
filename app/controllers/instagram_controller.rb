class InstagramController < ApplicationController
  before_action :authenticate_request

  def exchange_code_with_token
    insta = InstagramApiIntegration.new(current_user)
    status = insta.exchange_code_with_access_token(params["instagram"]["code"])
    render json: { status: status }
  end

  def get_user_instagram_media
    insta = InstagramApiIntegration.new(current_user)
    media = insta.get_user_recent_media
    render json: { instagram_media: media }
  end

  def check_user_is_instagram_authenticated
    insta = InstagramApiIntegration.new(current_user)
    token_status = insta.is_access_token_valid?
    render json: { instagram_authenticated: token_status }
  end

end
