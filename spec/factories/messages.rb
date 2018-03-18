# == Schema Information
#
# Table name: messages
#
#  id             :integer          not null, primary key
#  message        :text
#  user_id        :integer
#  recruitment_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :message do
    association :recruitment

    message 'ナンパ初心者です！よろしくお願いいたします！'
  end
end
