Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'users/fetch'
  post 'users' => 'users#sign_up'
  post 'users/:id/uploadavatar' => 'users#upload_avatar'
  get 'users' => 'users#index'
  get 'users/:id' => 'users#get'
  post 'users/login'
  post 'users/batch' => 'users#batch'
  get 'matches' => 'users#match'
  get 'matches/:id' => 'users#match_after'
end
