FactoryGirl.define do
  factory :tweet do
    association :user

    content Faker::Lorem.paragraphs[0..(Tweet::MAXIMUM_CONTENT_LENGTH - 1)]
  end
end
