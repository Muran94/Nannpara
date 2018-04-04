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

FactoryGirl.define do
  factory :blog_article do
    association :user

    sequence(:title) { |num| "ナンパについて本気で考えてみた 〜その#{num}〜" }
    content '詳細はまた別の記事にて'
  end
end
