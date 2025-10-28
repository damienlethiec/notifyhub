Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      post "login", to: "authentication#login"

      resources :organizations, only: [:index, :show]
      resources :notifications, only: [:index, :show, :create] do
        # Exercice 4 : Ajouter la route mark_as_read
        # member do
        #   post :mark_as_read
        # end
      end
    end
  end
end
