# == Schema Information
#
# Table name: ranking_types
#
#  id         :integer          not null, primary key
#  name_en    :string
#  name_ja    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :ranking_type do
    name_en "MyString"
    name_ja "MyString"
  end
end
