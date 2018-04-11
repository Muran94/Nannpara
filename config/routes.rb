Rails.application.routes.draw do
  root 'home#index'
  get '/home', to: 'home#index'
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
  resources :activities, only: [:create] do
    collection do
      get :show
      delete :destroy
    end
  end
  resources :blog_articles, controller: "blog/articles" do
    resources :blog_comments, only: [:create, :destroy], controller: "blog/comments" do
    end
  end
  get 'service/inquiry'
end
