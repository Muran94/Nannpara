# == Schema Information
#
# Table name: recruitments
#
#  id                                   :integer          not null, primary key
#  title                                :string
#  description                          :text
#  event_date                           :date
#  user_id                              :integer
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  prefecture_code                      :integer
#  linked_with_kanto_nanpa_messageboard :boolean
#  kanto_nanpa_messageboard_delete_key  :string
#  closed_at                            :datetime
#  messages_count                       :integer          default(0), not null
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
  validates :kanto_nanpa_messageboard_delete_key, length: { maximum: 6 }
  validate :_event_date_cannot_be_past

  jp_prefecture :prefecture_code

  before_create :_prepare_kanto_nanpa_messageboard_delete_key
  after_create :_register_activity
  before_save :_reset_closed_at_unless_past_recruitment

  def past_recruitment?
    event_date < Date.today
  end

  def owner?(current_user)
    current_user.id == user_id
  end

  private

  def _register_activity
    user.activities.create(activity_type_id: ActivityType.find_by_name_ja("募集記事の投稿").id)
  end

  def _event_date_cannot_be_past
    if event_date.present? && event_date < Date.today
      errors.add(:event_date, '開催日時に過去の日時を指定することはできません。')
    end
  end

  def _prepare_kanto_nanpa_messageboard_delete_key
    if kanto_nanpa_messageboard_delete_key.blank? && linked_with_kanto_nanpa_messageboard?
      self.kanto_nanpa_messageboard_delete_key = rand(100_000..999_999)
    end
  end

  def _reset_closed_at_unless_past_recruitment
    self.closed_at = nil unless past_recruitment?
  end
end
