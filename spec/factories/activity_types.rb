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
    name_jp "MyString"
    name_en "MyString"
    experience_point 1
  end
end
