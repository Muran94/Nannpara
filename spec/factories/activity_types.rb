# == Schema Information
#
# Table name: activity_types
#
#  id               :integer          not null, primary key
#  name_ja          :string
#  name_en          :string
#  experience_point :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :activity_type do
    name_ja "声かけ"
    name_en "talk"
    experience_point 3

    # 執筆系
    trait :post_recruitment_article do
      initialize_with do
        ActivityType.find_or_create_by(
          name_ja: "募集記事の投稿",
          name_en: "post_recruitment_article",
          experience_point: 3
        )
      end
    end
    trait :post_blog_article do
      initialize_with do
        ActivityType.find_or_create_by(
          name_ja: "ブログ記事の投稿",
          name_en: "post_blog_article",
          experience_point: 3
        )
      end
    end

    # リアルでのナンパ活動系
    trait :talk do
      initialize_with do
        ActivityType.find_or_create_by(
          name_ja: "声かけ",
          name_en: "talk",
          experience_point: 3
        )
      end
    end
    trait :get_phone_number do
      initialize_with do
        ActivityType.find_or_create_by(
          name_ja: "番ゲ",
          name_en: "get_phone_number",
          experience_point: 7
        )
      end
    end
    trait :date do
      initialize_with do
        ActivityType.find_or_create_by(
          name_ja: "連れ出し",
          name_en: "date",
          experience_point: 25
        )
      end
    end
    trait :instant_sex do
      initialize_with do
        ActivityType.find_or_create_by(
          name_ja: "即",
          name_en: "instant_sex",
          experience_point: 100
        )
      end
    end
    trait :sex_on_first_date do
      initialize_with do
        ActivityType.find_or_create_by(
          name_ja: "準即",
          name_en: "sex_on_first_date",
          experience_point: 75
        )
      end
    end
    trait :sex_on_second_date do
      initialize_with do
        ActivityType.find_or_create_by(
          name_ja: "準々即",
          name_en: "sex_on_second_date",
          experience_point: 50
        )
      end
    end

    # ランキング賞系
    # 「毎時の活動ランキング」系
    trait :hourly_activity_ranking_champion do
      initialize_with do
        ActivityType.find_or_create_by(
          name_ja: "毎時の活動ランキング優勝",
          name_en: "hourly_activity_ranking_champion",
          experience_point: 20
        )
      end
    end
    trait :hourly_activity_ranking_second_place do
      initialize_with do
        ActivityType.find_or_create_by(
          name_ja: "毎時の活動ランキング準優勝",
          name_en: "hourly_activity_ranking_second_place",
          experience_point: 15
        )
      end
    end
    trait :hourly_activity_ranking_third_place do
      initialize_with do
        ActivityType.find_or_create_by(
          name_ja: "毎時の活動ランキング3位",
          name_en: "hourly_activity_ranking_third_place",
          experience_point: 10
        )
      end
    end
    # 「本日の活動ランキング」系
    trait :daily_activity_ranking_champion do
      initialize_with do
        ActivityType.find_or_create_by(
          name_ja: "本日の活動ランキング優勝",
          name_en: "daily_activity_ranking_champion",
          experience_point: 50
        )
      end
    end
    trait :daily_activity_ranking_second_place do
      initialize_with do
        ActivityType.find_or_create_by(
          name_ja: "本日の活動ランキング準優勝",
          name_en: "daily_activity_ranking_second_place",
          experience_point: 40
        )
      end
    end
    trait :daily_activity_ranking_third_place do
      initialize_with do
        ActivityType.find_or_create_by(
          name_ja: "本日の活動ランキング3位",
          name_en: "daily_activity_ranking_third_place",
          experience_point: 30
        )
      end
    end
    # 「今月の活動ランキング」系
    trait :monthly_activity_ranking_champion do
      initialize_with do
        ActivityType.find_or_create_by(
          name_ja: "今月の活動ランキング優勝",
          name_en: "monthly_activity_ranking_champion",
          experience_point: 300
        )
      end
    end
    trait :monthly_activity_ranking_second_place do
      initialize_with do
        ActivityType.find_or_create_by(
          name_ja: "今月の活動ランキング準優勝",
          name_en: "monthly_activity_ranking_second_place",
          experience_point: 200
        )
      end
    end
    trait :monthly_activity_ranking_third_place do
      initialize_with do
        ActivityType.find_or_create_by(
          name_ja: "今月の活動ランキング3位",
          name_en: "monthly_activity_ranking_third_place",
          experience_point: 100
        )
      end
    end
  end
end
