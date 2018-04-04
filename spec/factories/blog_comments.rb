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

FactoryGirl.define do
  factory :blog_comment do
    association :user
    association :blog_article

    content "とても勇気の出る内容だと思いました！"

    trait :invalid_content do
      content "あ" * (BlogComment::MAXIMUM_CONTENT_LENGTH + 1)
    end
  end
end
