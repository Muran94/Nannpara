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

FactoryGirl.define do
  factory :tweet_comment do
    content "MyText"
    user nil
    tweet nil
  end
end
