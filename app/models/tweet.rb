# == Schema Information
#
# Table name: tweets
#
#  id                :integer          not null, primary key
#  content           :text
#  user_id           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  tweet_nices_count :integer          default(0), not null
#

class Tweet < ApplicationRecord
  belongs_to :user
  has_many :tweet_nices

  MAXIMUM_CONTENT_LENGTH = 140 # twitterとの連携を見越して文字数制限を同じにしている。
  validates :content, presence: true, length: { maximum: MAXIMUM_CONTENT_LENGTH }

  def owner?(current_user)
    current_user.id == user_id
  end
end
