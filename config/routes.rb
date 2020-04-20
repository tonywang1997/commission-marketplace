Rails.application.routes.draw do
  resources :tags
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#home'
  post '/', to: 'application#home'
  
  get 'sessions/new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'
  get '/dashboard', to: 'users#dashboard'
  get '/submit', to: 'portfolios#new', as: :user_submit
  get '/storefront/:user_id', to: 'portfolios#index'
  patch '/avatar', to: 'users#avatar'
  resources :users, param: :user_name
  resources :portfolios
end


# Routes ideas
# '/register' -> users#new
# '/dashboard' -> artists#edit for currently logged in artist?
# authentication/login
# '/storefront/username'