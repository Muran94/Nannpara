# == Schema Information
#
# Table name: rankings
#
#  id              :integer          not null, primary key
#  ranking_type_id :integer
#  start_at        :datetime
#  end_at          :datetime
#  closed_at       :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :ranking do
    association :ranking_type

    start_at nil
    end_at nil
    closed_at nil

    trait :monthly_activity_ranking do
      ranking_type {create(:ranking_type, :monthly_activity_ranking)}
    end

    trait :daily_activity_ranking do
      ranking_type {create(:ranking_type, :daily_activity_ranking)}
    end

    trait :hourly_activity_ranking do
      ranking_type {create(:ranking_type, :hourly_activity_ranking)}
    end

    trait :archived_hourly_activity_ranking do
      ranking_type {create(:ranking_type, :hourly_activity_ranking)}
      start_at 1.day.ago.beginning_of_day
      end_at 1.day.ago.end_of_day
      closed_at 1.day.ago.end_of_day
    end

    trait :with_a_entry do
      after(:create) do |ranking|
        create(:ranking_entry, ranking: ranking)
      end
    end
  end
end
