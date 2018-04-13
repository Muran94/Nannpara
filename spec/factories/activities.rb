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
    association :activity_type

    # 執筆系
    trait :post_recruitment_article_activity do
      activity_type {create(:activity_type, :post_recruitment_article)}
    end
    trait :post_blog_article_activity do
      activity_type {create(:activity_type, :post_blog_article)}
    end

    # リアルでのナンパ活動系
    trait :talk_activity do # 声かけ
      activity_type {create(:activity_type, :talk)} 
    end
    trait :get_phone_number_activity do # 番ゲ
      activity_type {create(:activity_type, :get_phone_number)}
    end
    trait :date_activity do # 連れ出し
      activity_type {create(:activity_type, :date)}
    end
    trait :instant_sex_activity do # 即
      activity_type {create(:activity_type, :instant_sex)}
    end
    trait :sex_on_first_date_activity do # 準即
      activity_type {create(:activity_type, :sex_on_first_date)}
    end
    trait :sex_on_second_date_activity do # 準々即
      activity_type {create(:activity_type, :sex_on_second_date)}
    end

    # ランキング賞系
    # 「毎時の活動ランキング」系
  end
end
