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

FactoryGirl.define do
  factory :tweet_nice do
    association :user
    association :tweet
  end
end
