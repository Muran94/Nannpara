# == Schema Information
#
# Table name: recruitments
#
#  id              :integer          not null, primary key
#  title           :string
#  description     :text
#  event_date      :datetime
#  venue           :string
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  prefecture_code :integer
#

FactoryGirl.define do
  factory :recruitment do
    association :user

    title 'ナンパ師仲間を募集しています！'
    description '本日の夜19:00〜出撃予定です！一人だと地蔵してしまいそうなので、お互いに励ましあいながら頑張りましょう！'
    prefecture_code 13
    venue '新宿歌舞伎町'
    event_date 1.day.from_now.to_time
  end
end
