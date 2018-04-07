class Blog::CommentsController < ApplicationController
  before_action :_set_blog_article
  before_action :_set_blog_comment, only: [:destroy]
  before_action :authenticate_user!
  before_action :_redirect_unless_blog_comment_owner_or_blog_article_owner, only: [:destroy]

  def create
    @blog_comment = @blog_article.blog_comments.build(_blog_comment_params)
    @blog_comment.user = current_user
    if @blog_comment.save
      flash[:success] = "コメントの投稿が完了しました。"
    else
      flash[:error] = "コメントの投稿に失敗しました。"
    end
    redirect_to @blog_article
  end

  def destroy
    @blog_comment.destroy
    flash[:success] = "コメントを削除しました。"
    redirect_to @blog_article
  end

  private

  def _set_blog_article
    @blog_article = Blog::Article.find(params[:blog_article_id])
  end

  def _set_blog_comment
    @blog_comment = @blog_article.blog_comments.find(params[:id])
  end

  def _blog_comment_params
    params.require(:blog_comment).permit(:content)
  end

  def _redirect_unless_blog_comment_owner_or_blog_article_owner
    unless @blog_comment.user == current_user || @blog_article.user == current_user
      flash[:error] = '不正な操作です。もう一度最初からやり直してください。'
      redirect_to @blog_article
    end
  end
end
