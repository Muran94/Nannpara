# == Schema Information
#
# Table name: blog_articles
#
#  id         :integer          not null, primary key
#  title      :string
#  content    :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BlogArticle < ApplicationRecord
  belongs_to :user
  has_many :blog_comments

  MAXIMUM_TITLE_LENGTH = 128
  validates :title, presence: true, uniqueness: true, length: { maximum: MAXIMUM_TITLE_LENGTH }
  MAXIMUM_CONTENT_LENGTH = 4096
  validates :content, presence: true, length: { maximum: MAXIMUM_CONTENT_LENGTH }

  def owner?(current_user)
    user == current_user
  end
end
