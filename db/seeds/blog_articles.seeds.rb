after :users do
  Faker::Config.locale = :ja

  maximum_title_length = BlogArticle::MAXIMUM_TITLE_LENGTH
  maximum_content_length = BlogArticle::MAXIMUM_CONTENT_LENGTH

  51.times do
    begin
      BlogArticle.create(
        title: Faker::Lorem.sentence[0..maximum_title_length],
        content: Faker::Lorem.paragraphs(rand(1..10)).join("\n\n")[0..maximum_content_length],
        user_id: User.all.to_a.sample.id
      )
    rescue => e
      puts %(\e[31m#{e}\e[0m)
    end
  end
end
