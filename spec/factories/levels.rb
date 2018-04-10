# == Schema Information
#
# Table name: levels
#
#  id                        :integer          not null, primary key
#  level                     :integer
#  required_experience_point :integer
#  rank                      :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

FactoryGirl.define do
  factory :level do
    level 1
    required_experience_point 1
    rank "MyString"
  end
end
