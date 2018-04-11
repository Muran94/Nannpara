# == Schema Information
#
# Table name: rankings
#
#  id              :integer          not null, primary key
#  ranking_type_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :ranking do
    ranking_type_id 1
  end
end
