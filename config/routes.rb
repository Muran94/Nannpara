Rails.application.routes.draw do
  root 'recruitments#index'
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :accounts, only: [] do
    member do
      get :profile
      get :recruitments
      get :blog_articles
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
  resources :counters, only: [:new, :create] do
    collection do
      delete :destroy
    end
  end
  resources :blog_articles, controller: "blog/articles" do
    resources :blog_comments, only: [:create, :destroy], controller: "blog/comments" do
    end
  end
  get 'service/inquiry'
end
