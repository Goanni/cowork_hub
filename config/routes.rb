Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get    "/login",  to: "sessions#new",     as: :login
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  get  "/signup", to: "users#new",    as: :signup
  post "/signup", to: "users#create"

  resources :zones, only: [:index, :show] do
    resources :workspaces, only: [:index]
  end
  resources :workspaces, only: [:show]

  root "zones#index"
end