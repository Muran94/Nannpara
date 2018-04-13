# == Schema Information
#
# Table name: ranking_types
#
#  id         :integer          not null, primary key
#  name_en    :string
#  name_ja    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :ranking_type do
    name_en "monthly_activity_ranking"
    name_ja "今月の活動ランキング"

    trait :monthly_activity_ranking do
      initialize_with do
        RankingType.find_or_create_by(
          name_en: "monthly_activity_ranking",
          name_ja: "今月の活動ランキング",
        )
      end
    end

    trait :daily_activity_ranking do
      initialize_with do
        RankingType.find_or_create_by(
          name_en: "daily_activity_ranking",
          name_ja: "本日の活動ランキング",
        )
      end
    end

    trait :hourly_activity_ranking do
      initialize_with do
        RankingType.find_or_create_by(
          name_en: "hourly_activity_ranking",
          name_ja: "毎時の活動ランキング",
        )
      end
    end
  end
end
