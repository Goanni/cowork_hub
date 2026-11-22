Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Аутентификация
  get    "/login",  to: "sessions#new",     as: :login
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  # Регистрация
  get  "/signup", to: "users#new",    as: :signup
  post "/signup", to: "users#create"

  # Зоны и рабочие места
  resources :zones, only: [:index, :show] do
    resources :workspaces, only: [:index]
  end
  resources :workspaces, only: [:show]

  # Бронирования
  resources :bookings, only: [:index, :show, :new, :create]

  root "zones#index"
end