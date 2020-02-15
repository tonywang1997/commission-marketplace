Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#home'
  get '/register',    to: 'users#new'
  # get '/dashboard',   to: 'users#edit'
  # get '/storefront',  to: 'users#show'
  resources :users

end


# Routes ideas
# '/register' -> users#new
# '/dashboard' -> artists#edit for currently logged in artist?
# authentication/login
# '/storefront/username'