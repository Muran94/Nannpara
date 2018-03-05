# == Schema Information
#
# Table name: recruitments
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  event_date  :datetime
#  venue       :string
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Recruitment < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: {maximum: 100}
  validates :description, length: {maximum: 5120}
  validates :venue, length: {maximum: 64}
  validate :_event_date_cannot_be_past

  def owner?(current_user)
    current_user.id == user_id
  end

  private

  def _event_date_cannot_be_past
    if event_date.present? && event_date < Time.zone.now
      errors.add(:event_date, "開催日は、未来の日時のみ指定可能です。")
    end
  end
end
