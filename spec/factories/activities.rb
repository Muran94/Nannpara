# == Schema Information
#
# Table name: activities
#
#  id                        :integer          not null, primary key
#  activity_type_id          :integer
#  obtained_experience_point :integer          default(0)
#  user_id                   :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

FactoryGirl.define do
  factory :activity do
    association :user

    activity_type "声かけ"

    trait :talk_activity do
      activity_type ActivityType.find_by_name_ja("声かけ")
    end

    trait :get_phone_number_activity do
      activity_type ActivityType.find_by_name_ja("番ゲ")
    end

    trait :date_activity do
      activity_type ActivityType.find_by_name_ja("連れ出し")
    end

    trait :instant_sex_activity do
      activity_type ActivityType.find_by_name_ja("即")
    end

    trait :sex_on_first_date do
      activity_type ActivityType.find_by_name_ja("準即")
    end

    trait :sex_on_second_date do
      activity_type ActivityType.find_by_name_ja("準々即")
    end
  end
end
