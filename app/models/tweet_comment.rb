# == Schema Information
#
# Table name: tweet_comments
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  tweet_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TweetComment < ApplicationRecord
  belongs_to :user
  belongs_to :tweet
end
