# == Schema Information
#
# Table name: tweets
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tweet < ApplicationRecord
  belongs_to :user

  MAXIMUM_CONTENT_LENGTH = 512
  validates :content, presence: true, length: {maximum: MAXIMUM_CONTENT_LENGTH}

  def owner?(current_user)
    current_user.id == user_id
  end
end
