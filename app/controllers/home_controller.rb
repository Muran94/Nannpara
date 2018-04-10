class HomeController < ApplicationController
  def index
    @recruitments = Recruitment.where(closed_at: nil).order({closed_at: :desc}, :event_date).includes(:user).limit(3)
    @blog_articles = Blog::Article.all.order('created_at DESC').includes(:user).limit(3)
  end
end
