Rails.application.routes.draw do
  devise_for :users
  resources :recruitments do
    resources :messages, only: [:create]
  end
  root "recruitments#index"
end
