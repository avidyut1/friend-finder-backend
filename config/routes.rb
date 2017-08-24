Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'users/fetch'
  post 'users/signup' => 'users#sign_up'
  post 'users/login'
end
