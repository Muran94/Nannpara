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
    activity_type {ActivityType.find_by_name_ja("声かけ")} 

    # 執筆系
    trait :post_recruitment_article_activity do
      activity_type {ActivityType.find_by_name_ja("募集記事の投稿")}
    end
    trait :post_blog_article_activity do
      activity_type {ActivityType.find_by_name_ja("ブログ記事の投稿")}
    end

    # リアルでのナンパ活動系
    trait :talk_activity do # 声かけ
      activity_type {ActivityType.find_by_name_ja("声かけ")} 
    end
    trait :get_phone_number_activity do # 番ゲ
      activity_type {ActivityType.find_by_name_ja("番ゲ")}
    end
    trait :date_activity do # 連れ出し
      activity_type {ActivityType.find_by_name_ja("連れ出し")}
    end
    trait :instant_sex_activity do # 即
      activity_type {ActivityType.find_by_name_ja("即")}
    end
    trait :sex_on_first_date_activity do # 準即
      activity_type {ActivityType.find_by_name_ja("準即")}
    end
    trait :sex_on_second_date_activity do # 準々即
      activity_type {ActivityType.find_by_name_ja("準々即")}
    end

    # ランキング賞系
    # 「毎時の活動ランキング」系
    trait :hourly_activity_ranking_champion do # 毎時の活動ランキング優勝
      activity_type {ActivityType.find_by_name_ja("毎時の活動ランキング優勝")}
    end
    trait :hourly_activity_ranking_second_place do # 毎時の活動ランキング準優勝
      activity_type {ActivityType.find_by_name_ja("毎時の活動ランキング準優勝")}
    end
    trait :hourly_activity_ranking_third_place do # 毎時の活動ランキング3位
      activity_type {ActivityType.find_by_name_ja("毎時の活動ランキング3位")}
    end
    # 「本日の活動ランキング」系
    trait :daily_activity_ranking_champion do # 本日の活動ランキング優勝
      activity_type {ActivityType.find_by_name_ja("本日の活動ランキング優勝")}
    end
    trait :daily_activity_ranking_second_place do # 本日の活動ランキング準優勝
      activity_type {ActivityType.find_by_name_ja("本日の活動ランキング準優勝")}
    end
    trait :daily_activity_ranking_third_place do # 本日の活動ランキング3位
      activity_type {ActivityType.find_by_name_ja("本日の活動ランキング3位")}
    end
    # 「今月の活動ランキング」系
    trait :monthly_activity_ranking_champion do # 今月の活動ランキング優勝
      activity_type {ActivityType.find_by_name_ja("今月の活動ランキング優勝")}
    end
    trait :monthly_activity_ranking_second_place do # 今月の活動ランキング準優勝
      activity_type {ActivityType.find_by_name_ja("今月の活動ランキング準優勝")}
    end
    trait :monthly_activity_ranking_third_place do # 今月の活動ランキング3位
      activity_type {ActivityType.find_by_name_ja("今月の活動ランキング3位")}
    end
  end
end
