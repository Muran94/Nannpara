FactoryGirl.define do
  factory :blog_article do
    association :user

    sequence(:title) { |num| "ナンパについて本気で考えてみた 〜その#{num}〜" }
    content '詳細はまた別の記事にて'
  end
end
