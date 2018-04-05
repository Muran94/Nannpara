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

require 'rails_helper'

RSpec.describe TweetComment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
