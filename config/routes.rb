Rails.application.routes.draw do
  resources :cats
  resources :cat_rental_requests, only: [:new, :create] do
    post '/approve' => 'cat_rental_requests#approve', :as => 'approve'
    post '/deny' => 'cat_rental_requests#deny', :as => 'deny'
  end

end
