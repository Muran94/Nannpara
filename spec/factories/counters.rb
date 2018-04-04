# == Schema Information
#
# Table name: counters
#
#  id           :integer          not null, primary key
#  counter_type :string
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :counter do
    association :user

    counter_type '声かけ'
  end
end
