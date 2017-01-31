Rails.application.routes.draw do
  # get 'users/create'

  get 'users/:user_id/trips', to: 'trips#get_user_trips'
  post 'trips/search', to: 'trips#search'
  post 'trips/like', to: 'trips#like'
  get 'trending/trips', to: 'trips#trending'
  resources :trips
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'authenticate', to: 'authentication#authenticate'
  post 'users/create', to: 'users#create'
  post 'users/show', to: 'users#show'
  post 'users/auth_user', to: 'users#auth_user'
  post 'users/:id', to: 'users#get_user_by_id'
  post 'update_user_profile_media', to: 'users#update_user_profile_media'
  post 'add_to_user_following_list', to: 'users#add_traveller_to_user_following_list'
  post 'user_followers', to: 'users#get_user_followers'
  post 'user_following', to: 'users#get_user_following'

# instagram related routes
  get 'is_user_instagram_authenticated', to: 'instagram#check_user_is_instagram_authenticated'
  get 'get_user_instagram_media', to: 'instagram#get_user_instagram_media'
  post 'exchange_code_with_token', to: 'instagram#exchange_code_with_token'

end
