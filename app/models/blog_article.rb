class BlogArticle < ApplicationRecord
  belongs_to :user

  MAXIMUM_TITLE_LENGTH = 128
  validates :title, presence: true, uniqueness: true, length: { maximum: MAXIMUM_TITLE_LENGTH }
  MAXIMUM_CONTENT_LENGTH = 4096
  validates :content, presence: true, length: { maximum: MAXIMUM_CONTENT_LENGTH }

  def owner?(current_user)
    current_user.id == user_id
  end
end
