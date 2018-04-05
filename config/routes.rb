Rails.application.routes.draw do
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
  resources :tweets, only: [:index, :show, :new, :create, :destroy] do
    resources :tweet_nices, only: [:create] do
      collection do
        delete :destroy
      end
    end
  end
  resources :counters, only: [:new, :create]
  resources :blog_articles do
    resources :blog_comments, only: [:create, :destroy] do
    end
  end
  get 'service/inquiry'
end
