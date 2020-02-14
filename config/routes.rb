Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#home'
  get '/register',    to: 'users#new'
  get '/dashboard',   to: 'artists#edit'
  get '/storefront',  to: 'artists#show'
end
