class Blog::ArticlesController < ApplicationController
  before_action :_set_blog_article, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :_redirect_unless_owner, only: [:edit, :update, :destroy]

  # GET /blog_articles
  def index
    @blog_articles = Blog::Article.all.order('created_at DESC').includes(:user).page(params[:page])
  end

  # GET /blog_articles/1
  def show
    @new_blog_comment = Blog::Comment.new
    @blog_comments = @blog_article.blog_comments.order("created_at DESC").includes(:user).page(params[:page])
  end

  # GET /blog_articles/new
  def new
    @blog_article = current_user.blog_articles.build
  end

  # POST /blog_articles
  def create
    @blog_article = current_user.blog_articles.build(_blog_article_params)
    if @blog_article.save
      flash[:success] = 'ブログの投稿が完了しました。'
      redirect_to @blog_article
    else
      flash[:error] = 'ブログの投稿に失敗しました。'
      render :new
    end
  end

  def edit; end

  def update
    if @blog_article.update(_blog_article_params)
      flash[:success] = 'ブログの更新が完了しました。'
      redirect_to @blog_article
    else
      flash[:error] = 'ブログの更新に失敗しました。'
      render :edit
    end
  end

  def destroy
    @blog_article.destroy
    flash[:success] = 'ブログ記事の削除が完了しました。'
    redirect_to blog_articles_path
  end

  private

  def _set_blog_article
    @blog_article = Blog::Article.find(params[:id])
  end

  def _blog_article_params
    params.require(:blog_article).permit(:title, :content)
  end

  def _redirect_unless_owner
    unless @blog_article.user == current_user
      flash[:error] = '不正な操作です。もう一度最初からやり直してください。'
      redirect_to blog_articles_path
    end
  end
end
