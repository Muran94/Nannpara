after :users do
  Faker::Config.locale = :ja
  51.times do
    Tweet.create(
      content: Faker::Lorem.paragraphs(rand(1..10)).join("\n\n")[0..Tweet::MAXIMUM_CONTENT_LENGTH],
      user_id: User.all.to_a.sample.id
    )
  end
end
