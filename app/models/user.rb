# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  failed_attempts        :integer          default(0), not null
#  locked_at              :datetime
#  name                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  introduction           :text
#  experience             :string
#  age                    :integer
#  prefecture_code        :integer
#  image                  :string
#  direct_mail            :boolean
#

class User < ApplicationRecord
  include JpPrefecture
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  jp_prefecture :prefecture_code
  mount_uploader :image, ProfileImageUploader

  has_many :recruitments, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :tweets, dependent: :destroy
  has_many :counters, dependent: :destroy

  MAXIMUM_NAME_LENGTH = 16
  validates :name, uniqueness: true, presence: true, length: { maximum: MAXIMUM_NAME_LENGTH }, exclusion: {in: %w(南原 南原さん 管理人)}
  MAXIMUM_INTRODUCTION_LENGTH = 5120
  validates :introduction, length: { maximum: MAXIMUM_INTRODUCTION_LENGTH }
  MINIMUM_AGE = 18
  MAXIMUM_AGE = 100
  validates :age, allow_blank: true, inclusion: { in: MINIMUM_AGE..MAXIMUM_AGE }
  MAXIMUM_EXPERIENCE_LENGTH = 32
  validates :experience, length: { maximum: MAXIMUM_EXPERIENCE_LENGTH }
  validate :_valid_image_size?


  def thumb_image_url
    return 'no_user_image.png' if image.blank?
    image.thumb.url
  end

  private

  def _valid_image_size?
    if image.size > 5.megabytes
      errors.add(:image, "画像のファイルサイズが大きすぎます。5MB以下の画像を選択してください。")
    end
  end
end
