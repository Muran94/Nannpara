after :users, :blog_articles do
  Faker::Config.locale = :ja


  BlogArticle.all.each do |blog_article|
    next if rand(1..100) <= 30 # 30%の確率でメッセージなし
    rand(1..51).times do
      blog_article.blog_comments.create(
        content: Faker::Lorem.paragraphs(1..10).join("\n\n")[0...BlogComment::MAXIMUM_CONTENT_LENGTH],
        user_id: User.all.to_a.sample.id
      )
    end
  end
end
