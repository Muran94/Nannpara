Rails.application.routes.draw do
  get 'blog_comments/create'

  get 'blog_comments/destroy'

  get 'comments/create'

  get 'comments/destroy'

  root 'recruitments#index'
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :accounts, only: [] do
    member do
      get :profile
      get :recruitments
      get :blog_articles
      get :tweets
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
  resources :recruitments do
    resources :messages, only: [:create]
  end
  resources :tweets, only: [:index, :show, :new, :create, :destroy]
  resources :counters, only: [:new, :create]
  resources :blog_articles do
    resources :blog_comments, only: [:create, :destroy]
  end
  get 'service/inquiry'
end
