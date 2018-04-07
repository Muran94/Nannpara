# == Schema Information
#
# Table name: blog_comments
#
#  id              :integer          not null, primary key
#  content         :text
#  user_id         :integer
#  blog_article_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Blog::Comment < ApplicationRecord
  belongs_to :user
  belongs_to :blog_article, foreign_key: "blog_article_id", class_name: "Blog::Article"

  MAXIMUM_CONTENT_LENGTH = 512
  validates :content, presence: true, length: {maximum: MAXIMUM_CONTENT_LENGTH}

  def owner?(current_user)
    user == current_user
  end
end
