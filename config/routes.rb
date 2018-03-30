Rails.application.routes.draw do
  root 'recruitments#index'
  resources :accounts, only: [] do
    member do
      get :profile
      get :recruitments
    end
    collection do
      get :edit
      patch :update
      get :edit_image
      patch :update_image
      patch :destroy_image
      get :edit_password
      patch :update_password
    end
  end
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :recruitments do
    resources :messages, only: [:create]
  end
  get "service/inquiry"
end
