after :users do
  Faker::Config.locale = :ja

  51.times do
    begin
      Blog::Article.create(
        title: Faker::Lorem.sentence[0...Blog::Article::MAXIMUM_TITLE_LENGTH],
        content: Faker::Lorem.paragraphs(rand(1..10)).join("\n\n")[0...Blog::Article::MAXIMUM_CONTENT_LENGTH],
        user_id: User.all.to_a.sample.id
      )
    rescue => e
      puts %(\e[31m#{e}\e[0m)
    end
  end
end
