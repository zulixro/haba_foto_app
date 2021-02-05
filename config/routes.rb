Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get '/admin', :to => 'sessions#admin_new'
  end

  resources :albums do
    member do
      put :edit_photos
    end
  end
  resources :photos

  root to: "albums#index"
end
