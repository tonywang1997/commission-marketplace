Rails.application.routes.draw do
  get 'favorites/update'
  get 'roles/new'
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
  patch '/biography', to: 'users#biography'

  resources :portfolios, only: [:index, :show, :new, :create]
  get '/submit', to: 'portfolios#new', as: :user_submit
  get '/storefront', to: 'portfolios#index'

  resources :posts
  get '/post', to: 'posts#index'

  resources :favorites
  get '/favorite', to: 'favorite#index'

  resources :messages, only: [:index, :new, :create]
  get '/conversation', to: 'messages#index'

  mount ActionCable.server, at: '/cable'

  resources :images do
    put :favorite, on: :member
  end

end


# Routes ideas
# '/register' -> users#new
# '/dashboard' -> artists#edit for currently logged in artist?
# authentication/login
# '/storefront/username'