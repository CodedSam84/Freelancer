Rails.application.routes.draw do
  get '/dashboard', to: 'users#dashboard'
  post '/users/edit', to: 'users#update'
  get 'users/:id', to: 'users#show'

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'profile' },
  controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations' }
  root to: "pages#home"
end
