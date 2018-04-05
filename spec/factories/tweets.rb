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

FactoryGirl.define do
  factory :tweet do
    association :user

    content Faker::Lorem.paragraphs.join("\n")[0..(Tweet::MAXIMUM_CONTENT_LENGTH - 1)]

    trait :with_a_single_tweet_nice do
      after(:create) do |tweet|
        create(:tweet_nice, tweet: tweet)
      end
    end
  end
end
