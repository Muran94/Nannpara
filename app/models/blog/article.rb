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

class Blog::Article < ApplicationRecord
  belongs_to :user
  has_many :blog_comments, foreign_key: "blog_article_id", class_name: "Blog::Comment"

  after_create :_register_activity

  MAXIMUM_TITLE_LENGTH = 128
  validates :title, presence: true, length: { maximum: MAXIMUM_TITLE_LENGTH }, uniqueness: { scope: [:user_id]  }
  MAXIMUM_CONTENT_LENGTH = 4096
  validates :content, presence: true, length: { maximum: MAXIMUM_CONTENT_LENGTH }

  def owner?(current_user)
    user == current_user
  end

  private

    def _register_activity
      user.activities.create(activity_type_id: ActivityType.find_by_name_ja("ブログ記事の投稿").id)
  end
end
