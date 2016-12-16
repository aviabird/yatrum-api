class InstagramApiIntegration
  def initialize(user)
    @client = HTTPClient.new
    @user = user
  end

  def access_token_params(code)
    {
      'client_id': ENV['CLIENT_ID'],
      'client_secret': ENV['CLIENT_SECRET'],
      'grant_type': 'authorization_code',
      'redirect_uri': ENV['REDIRECT_URI'],
      'code': code
    }
  end

  
# This will return the instagram access token of the user,
# which is required for authentication with instagram endpoints 
  def get_user_access_token 
    @user.instagram_access_token
  end

# Get the most recent media published by the owner of the access_token.
# for more information, visit https://www.instagram.com/developer/endpoints/users/
  def get_user_recent_media
    response = @client.get("https://api.instagram.com/v1/users/self/media/recent", access_token: get_user_access_token)
    medias = JSON.parse(response.body)    
    if(medias["meta"]["code"] == 200)
      media_url = []
      medias["data"].each do |media|
        url = media["images"]["standard_resolution"]["url"]
        media_url.push(url)
      end
      media_url  
    end
  end

# Gives Information about the owner of the access token
# for more information, visit https://www.instagram.com/developer/endpoints/users/
  def get_user_instagram_profile
    response = @client.get("https://api.instagram.com/v1/users/self", access_token: get_user_access_token)
    user_profile = JSON.parse(response.body)
  end


# Exchange the code with the user access token 
# for more information, visit https://www.instagram.com/developer/authentication/
  def exchange_code_with_access_token(code)
    response = @client.post("https://api.instagram.com/oauth/access_token", access_token_params(code))
    data = JSON.parse(response.body)
    access_token = data["access_token"]
    # binding.pry
    if(access_token)
      set_user_instagram_profile(data, access_token)
      "success"  
    else
      "failure"
    end
  end

  def set_user_instagram_profile(data, access_token)
    user_name = data["user"]["username"]
    profile_picture = data["user"]["profile_picture"]
    @user.update_attributes(
                            instagram_access_token: access_token, 
                            instagram_user_name: user_name,
                            instagram_profile_picture: profile_picture
                            ) 
  end

# check if the access_token which is saved in the user database, is valid or not
# so we are hitting instagram endpoint with the current access token and checking
# for the code status 200.
  def is_access_token_valid?
    response = @client.get("https://api.instagram.com/v1/users/self", access_token: get_user_access_token )
    code_status = JSON.parse(response.body)["meta"]["code"]
    code_status == 200 ? true : false
  end

end    