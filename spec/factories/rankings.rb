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
    ranking_type {RankingType.find_by_name_ja("毎時の活動ランキング")}

    start_at nil
    end_at nil
    closed_at nil

    trait :monthly_activity_ranking do
      ranking_type {RankingType.find_by_name_ja("今月の活動ランキング")}
    end

    trait :daily_activity_ranking do
      ranking_type {RankingType.find_by_name_ja("本日の活動ランキング")}
    end

    trait :hourly_activity_ranking do
      ranking_type {RankingType.find_by_name_ja("毎時の活動ランキング")}
    end

    trait :archived_hourly_activity_ranking do
      ranking_type {RankingType.find_by_name_ja("毎時の活動ランキング")}
      yesterday = 1.day.ago
      start_at yesterday.beginning_of_day
      end_at yesterday.end_of_day
      closed_at yesterday.end_of_day
    end

    trait :with_a_entry do
      after(:create) do |ranking|
        create(:ranking_entry, ranking: ranking)
      end
    end
  end
end
