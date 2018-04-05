after :users do
  Faker::Config.locale = :ja

  51.times do
    begin
      BlogArticle.create(
        title: Faker::Lorem.sentence[0...BlogArticle::MAXIMUM_TITLE_LENGTH],
        content: Faker::Lorem.paragraphs(rand(1..10)).join("\n\n")[0...BlogArticle::MAXIMUM_CONTENT_LENGTH],
        user_id: User.all.to_a.sample.id
      )
    rescue => e
      puts %(\e[31m#{e}\e[0m)
    end
  end
end
