# == Schema Information
#
# Table name: recruitments
#
#  id              :integer          not null, primary key
#  title           :string
#  description     :text
#  event_date      :datetime
#  venue           :string
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  prefecture_code :integer
#

class Recruitment < ApplicationRecord
  include JpPrefecture

  belongs_to :user
  has_many :messages, dependent: :destroy

  MAXIMUM_TITLE_LENGTH = 64
  validates :title, presence: true, length: { maximum: MAXIMUM_TITLE_LENGTH }
  MAXIMUM_DESCRIPTION_LENGTH = 1024
  validates :description, presence: true, length: { maximum: MAXIMUM_DESCRIPTION_LENGTH }
  validates :prefecture_code, inclusion: { in: JpPrefecture::Prefecture.all.map(&:code) }
  MAXIMUM_VENUE_LENGTH = 16
  validates :venue, presence: true, length: { maximum: MAXIMUM_VENUE_LENGTH }
  validate :_event_date_cannot_be_past

  jp_prefecture :prefecture_code

  def owner?(current_user)
    current_user.id == user_id
  end

  private

  def _event_date_cannot_be_past
    if event_date.present? && event_date < Time.zone.now
      errors.add(:event_date, '開催日時に過去の日時を指定することはできません。')
    end
  end
end
