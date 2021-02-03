Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :albums do
    member do
      put :edit_photos
    end
  end
  resources :photos
  root to: "albums#index"
end
