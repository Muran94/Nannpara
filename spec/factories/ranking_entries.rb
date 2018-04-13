# == Schema Information
#
# Table name: ranking_entries
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  ranking_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :ranking_entry do
    association :user
    association :ranking
  end
end
