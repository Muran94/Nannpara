# == Schema Information
#
# Table name: tweet_nices
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  tweet_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TweetNice < ApplicationRecord
  belongs_to :user
  belongs_to :tweet
  counter_culture :tweet

  validates :user_id, uniqueness: { scope: :tweet_id } # user_idとtweet_idの組み合わせによるユニークのバリデーション
end
