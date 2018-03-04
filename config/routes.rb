Rails.application.routes.draw do
  devise_for :users
  resources :recruitments
  root "recruitments#index"
end
