class TweetsController < ApplicationController
  before_action :_set_tweet, only: [:show, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :_tweet_owner?, only: [:destroy]

  def index
    @tweets = Tweet.all.order('tweets.created_at DESC').includes(:user).page(params[:page])
  end

  def show; end

  def new
    @tweet = current_user.tweets.build
  end

  def create
    @tweet = current_user.tweets.build(_tweet_params)
    if @tweet.save
      flash[:success] = 'つぶやきが完了しました。'
      redirect_to tweets_path
    else
      flash[:error] = 'つぶやけませんでした。'
      render :new
    end
  end

  def destroy
    @tweet.destroy
    flash[:success] = 'つぶやきの削除が完了しました。'
    redirect_to tweets_path
  end

  private

  def _tweet_params
    params.require(:tweet).permit(:content)
  end

  def _set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def _tweet_owner?
    unless @tweet.user == current_user
      flash[:error] = '不正な操作です。もう一度最初からやり直してください。'
      redirect_to tweets_path
    end
  end
end
