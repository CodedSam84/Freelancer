Rails.application.routes.draw do
  root to: "pages#home"

  resources :gigs do
    member do
      post 'upload_photo'
      delete 'delete_photo'
    end

    resources :orders, only: [:create]
  end

  get '/dashboard', to: 'users#dashboard'
  get 'users/:id', to: 'users#show'

  post '/users/edit', to: 'users#update'

  devise_for :users,
              path: '', 
              path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'profile' },
              controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations' }

end
