# == Schema Information
#
# Table name: tweets
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :tweet do
    association :user

    content Faker::Lorem.paragraphs.join("\n")[0..(Tweet::MAXIMUM_CONTENT_LENGTH - 1)]
  end
end
