FactoryGirl.define do
  factory :counter do
    association :user

    counter_type '声かけ'
  end
end
