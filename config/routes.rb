Rails.application.routes.draw do
  # Root page — can show login or dashboard
  root to: 'sessions#new'

  # User signup
  get  '/signup', to: 'users#new',    as: :signup
  post '/signup', to: 'users#create'

  # Session login/logout
  get    '/login',  to: 'sessions#new',    as: :login
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: :logout

  get '/home', to: "home#index"
end
