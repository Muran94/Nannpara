Rails.application.routes.draw do
  get 'messages/create'

  devise_for :users
  resources :recruitments
  root "recruitments#index"
end
