Rails.application.routes.draw do
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # get 'users/create'
  
  devise_for :users
  
  # Made For Devise intergation 
  # TODO: Should be changed to yatrums home index
  root to: "home#index"



  get 'users/:user_id/trips', to: 'trips#get_user_trips'
  post 'trips/search', to: 'trips#search'
  post 'trips/like', to: 'trips#like'
  get 'trending/trips', to: 'trips#trending'
  get 'trips/:id/comments', to: 'trips#comments'
  post 'trips/comments', to: 'trips#delete_comment'
  post 'trips/add_comments', to: 'trips#add_comment'
  post 'trips/increase_view_count', to: 'trips#increase_view_count'
  resources :trips
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'auth/:provider', to: 'authentication#social_authenticate'
  post 'authenticate', to: 'authentication#authenticate'
  post 'users/create', to: 'users#create'
  post 'users/show', to: 'users#show'
  post 'users/auth_user', to: 'users#auth_user'
  post 'users/update_social_links', to: 'users#update_social_links'
  post 'users/:id', to: 'users#get_user_by_id'
  post 'update_user_profile_media', to: 'users#update_user_profile_media'
  post 'add_to_user_following_list', to: 'users#add_traveller_to_user_following_list'
  post 'follow_trip_user', to: 'users#follow_trip_user'
  post 'user_followers', to: 'users#get_user_followers'
  post 'user_following', to: 'users#get_user_following'
  post 'update_password', to: 'users#update_password'
  post 'user_pictures', to: 'users#get_user_pictures'
  post 'update_user_followers', to: 'users#update_user_followers'
  post 'update_user_following', to: 'users#update_user_following'

# instagram related routes
  get 'is_user_instagram_authenticated', to: 'instagram#check_user_is_instagram_authenticated'
  get 'get_user_instagram_media', to: 'instagram#get_user_instagram_media'
  post 'exchange_code_with_token', to: 'instagram#exchange_code_with_token'

end
