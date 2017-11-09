Rails.application.routes.draw do
 

  root 'pages#home'

  devise_for :users,
              path: '',
              path_names: {sign_in: 'login', sign_out: 'logout', edit: 'profile', sign_up: 'registration'},
              controllers: {omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations'}

  resources :users, only: [:show]
  resources :cars, except: [:edit] do
    member do
      get 'listing'
      get 'pricing'
      get 'description'
      get 'photo_upload'
      get 'location'
      get 'preload'
      get 'preview'
    end

    resources :photos, only: [:create, :destroy]
    resources :reservations, only: [:create]

  end

    resources :renter_reviews, only: [:create, :destroy]
    resources :owner_reviews, only: [:create, :destroy]

    get '/your_trips' => 'reservations#your_trips'
    get '/your_reservations' => 'reservations#your_reservations'
end
