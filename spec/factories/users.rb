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
#  name                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  introduction           :text
#  experience             :string
#  age                    :integer
#  prefecture_code        :integer
#

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'

    name Faker::Name.name[0..User::MAXIMUM_NAME_LENGTH]
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
  end
end
