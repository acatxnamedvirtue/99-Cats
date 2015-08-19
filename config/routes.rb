Rails.application.routes.draw do
  root "cats#index"

  resources :cats
  resources :cat_rental_requests, only: [:new, :create] do
    member do
      post "approve"
      post "deny"
    end
  end
  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
  get "/other_sessions", to: "sessions#signins", as: "signins"
  delete "/other_sessions", to: "sessions#other_signout", as: "other_signout"
end
