after :users, :recruitments do
  Faker::Config.locale = :ja

  USER_SAMPLES = [nil, User.all.to_a].flatten

  Recruitment.all.each do |recruitment|
    next if rand(1..100) <= 30 # 30%の確率でメッセージなし
    rand(1..51).times do
      recruitment.messages.create(
        message: Faker::Lorem.paragraphs(1..10).join("\n\n")[0...Message::MAXIMUM_MESSAGE_LENGTH],
        user_id: USER_SAMPLES.sample&.id
      )
    end
  end
end
