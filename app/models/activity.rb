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

class Activity < ApplicationRecord
  belongs_to :activity_type
  belongs_to :user

  before_create :_set_obtained_experience_point
  after_create :_update_users_experience_point
  after_destroy :_update_users_experience_point

  validates :activity_type_id, inclusion: {in: ActivityType.pluck(:id)}

  private

  def _set_obtained_experience_point
    self.obtained_experience_point = activity_type.experience_point
  end

  def _update_users_experience_point
    user.experience_point = user.activities.sum(:obtained_experience_point)
    user.save(validate: false)
  end
end
