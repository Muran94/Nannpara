# == Schema Information
#
# Table name: recruitments
#
#  id                                   :integer          not null, primary key
#  title                                :string
#  description                          :text
#  event_date                           :date
#  user_id                              :integer
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  prefecture_code                      :integer
#  linked_with_kanto_nanpa_messageboard :boolean
#  kanto_nanpa_messageboard_delete_key  :string
#  closed_at                            :datetime
#  messages_count                       :integer          default(0), not null
#

FactoryGirl.define do
  factory :recruitment do
    association :user

    title 'ナンパ師仲間を募集しています！'
    description '本日の夜19:00〜出撃予定です！一人だと地蔵してしまいそうなので、お互いに励ましあいながら頑張りましょう！'
    prefecture_code 13
    event_date 1.day.from_now.to_date

    trait :without_validation do
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
