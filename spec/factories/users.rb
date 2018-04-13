# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  failed_attempts        :integer          default(0), not null
#  locked_at              :datetime
#  name                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  introduction           :text
#  experience             :string
#  age                    :integer
#  prefecture_code        :integer
#  image                  :string
#  direct_mail            :boolean
#  experience_point       :integer          default(0)
#  level_id               :integer          default(1)
#

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'

    sequence(:name) { |n| "ナンパ師#{n}号" }
    introduction 'ナンパ初心者です！よろしくお願いします！'
    experience '3年'
    age 33
    prefecture_code 13 # 東京都
    image Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/image/sample_image.jpg'))

    trait :without_profile do
      introduction nil
      experience nil
      age nil
      prefecture_code nil
      image nil
    end

    trait :with_recruitments do
      after(:create) do |user|
        create_list(:recruitment, 3, user: user)
      end
    end

    trait :with_blog_articles do
      after(:create) do |user|
        create_list(:blog_article, 3, user: user)
      end
    end

    trait :with_three_ranking_entries do
      after(:create) do |user|
        create(:ranking, :hourly_activity_ranking)
        create(:ranking, :daily_activity_ranking)
        create(:ranking, :monthly_activity_ranking)

        create(:activity, :talk_activity, user: user)
      end
    end

    trait :with_three_talk_activities do
      after(:create) do |user|
        create_list(:activity, 3, :talk_activity, user: user)
      end
    end

    trait :with_single_talk_activity do
      after(:create) do |user|
        create(:activity, :talk_activity, user: user)
      end
    end

    trait :with_single_get_phone_number_activity do
      after(:create) do |user|
        create(:activity, :get_phone_number_activity, user: user)
      end
    end

    trait :with_single_date_activity do
      after(:create) do |user|
        create(:activity, :date_activity, user: user)
      end
    end

    trait :with_single_instant_sex_activity do
      after(:create) do |user|
        create(:activity, :instant_sex_activity, user: user)
      end
    end

    trait :with_single_sex_on_first_date_activity do
      after(:create) do |user|
        create(:activity, :sex_on_first_date_activity, user: user)
      end
    end

    trait :with_single_sex_on_second_date do
      after(:create) do |user|
        create(:activity, :sex_on_second_date_activity, user: user)
      end
    end
  end
end
