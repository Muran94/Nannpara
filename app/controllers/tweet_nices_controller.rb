class TweetNicesController < ApplicationController
  before_action :authenticate_user!
  before_action :_set_tweet
  before_action :_set_tweet_nice

  def create
    unless @tweet_nice.new_record?
      logger.error "既に「いいね」されています"
      return render json: { status: 'tweet_nice_duplicated' }
    end

    if @tweet_nice.save
      render json: { status: :created }
    else
      render json: { status: :unprocessable_entity }
    end
  end

  def destroy
    # 既に「いいね」が解除されていないかチェック
    if @tweet_nice.new_record?
      logger.error "既に「いいね」が解除されています。"
      return render json: { status: 'already_deleted' }
    end

    @tweet_nice.destroy
    render json: { status: 'deleted' }
  end

  private

  def _set_tweet
    @tweet = Tweet.find(params[:tweet_id])
  end

  def _set_tweet_nice
    @tweet_nice = @tweet.tweet_nices.find_or_initialize_by(user_id: current_user.id, tweet_id: params[:tweet_id])
  end
end
