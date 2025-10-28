Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", :as => :rails_health_check

  namespace :api do
    namespace :v1 do
      post "login", to: "authentication#login"

      resources :organizations, only: [:index, :show]
      resources :notifications, only: [:index, :show, :create] do
      end
    end
  end
end
