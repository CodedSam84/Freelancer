Rails.application.routes.draw do
  
  root to: "pages#home"

  get '/selling_orders', to: 'orders#selling_orders'
  get '/buying_orders', to: 'orders#buying_orders'

  put '/orders/:id/complete', to: 'orders#complete', as: 'complete_order'
  put '/offers/:id/accept', to: 'offers#accept', as: 'accept_offer'
  put '/offers/:id/reject', to: 'offers#reject', as: 'reject_offer'

  get '/all_requests', to: 'requests#list'

  resources :gigs do
    member do
      post 'upload_photo'
      delete 'delete_photo'
    end

    resources :orders, only: [:create]
  end

  resources :requests

  get '/dashboard', to: 'users#dashboard'
  get 'users/:id', to: 'users#show', as: 'user'
  get '/request_offers/:id', to: 'requests#offers', as: 'request_offers'
  get '/my_offers', to: 'offers#my_offers', as: 'my_offers'
  get '/search', to: 'pages#search', as: 'search'
  get '/settings/payment', to: 'users#payment'

  post '/users/edit', to: 'users#update'
  post '/offers', to: 'offers#create'
  post '/reviews', to: 'reviews#create'

  devise_for :users,
              path: '', 
              path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'profile' },
              controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations' }

end
