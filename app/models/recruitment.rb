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

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 5120 }
  validates :prefecture_code, inclusion: { in: JpPrefecture::Prefecture.all.map(&:code) }
  validates :venue, presence: true, length: { maximum: 32 }
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
