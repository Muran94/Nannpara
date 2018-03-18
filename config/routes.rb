Rails.application.routes.draw do
  resources :accounts, only: [] do
    member do
      get :profile
      get :recruitments
    end
    collection do
      get :edit
      patch :update
      get :edit_password
      patch :update_password
    end
  end
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :recruitments do
    resources :messages, only: [:create]
  end
  root 'recruitments#index'
end
