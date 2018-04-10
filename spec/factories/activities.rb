# == Schema Information
#
# Table name: activities
#
#  id                        :integer          not null, primary key
#  activity_type_id          :integer
#  obtained_experience_point :integer          default(0)
#  user_id                   :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

FactoryGirl.define do
  factory :activity do
    activity_type nil
    user nil
  end
end
