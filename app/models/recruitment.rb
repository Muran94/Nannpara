class Recruitment < ApplicationRecord
  belongs_to :user

  def owner?(current_user)
    current_user.id == user_id
  end
end
