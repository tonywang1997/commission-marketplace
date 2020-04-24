Rails.application.routes.draw do
  resources :tags
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#home'
  post '/', to: 'application#home'
  
  get 'sessions/new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users, param: :user_name
  get '/register', to: 'users#new'
  post '/register', to: 'users#create'
  get '/dashboard', to: 'users#dashboard'
  patch '/avatar', to: 'users#avatar'
  
  resources :portfolios
  get '/submit', to: 'portfolios#new', as: :user_submit
  get '/storefront/:user_id', to: 'portfolios#index'

  resources :posts
  get '/post', to: 'posts#index'
end


# Routes ideas
# '/register' -> users#new
# '/dashboard' -> artists#edit for currently logged in artist?
# authentication/login
# '/storefront/username'