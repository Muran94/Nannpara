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

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :recruitment

  validates :message, presence: true, length: {maximum: 1024}
end
