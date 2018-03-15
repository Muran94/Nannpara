Faker::Config.locale = :ja
titles = %w[
  今日の１９時から出撃予定！仲間募集中！
  新宿歌舞伎町でソロナンパします！５名募集中
  初心者です！よろしくお願いします！
  ソロ
  スト仲間募集
  ナンパを学んで人生をより良くしたい方必見！
  ストリートナンパ即ゲ目指して頑張りましょう！
  番ゲ50人達成まで帰れま10
]
titles << Faker::Lorem.characters(100)

User.create(name: Faker::Name.name[0..64], email: "shimono@gmail.com", password: "password")
User.create(name: Faker::Name.name[0..64], email: "takashi@gmail.com", password: "password")
User.create(name: Faker::Name.name[0..64], email: "down@gmail.com", password: "password")

1000.times do
  begin
    recruitment = Recruitment.create(
      title: titles.sample,
      description: Faker::Lorem.paragraphs(rand(1..10)).join("\n\n")[0..5120],
      prefecture_code: rand(1..47),
      venue: %w[渋谷ハチ公前 新宿歌舞伎町 新橋 池袋東口 川崎].sample,
      event_date: rand(1..30).days.from_now,
      user_id: User.all.to_a.sample.id
    )
    users = [nil, User.all.to_a].flatten
    rand(1..200).times do
      recruitment.messages.create(message: Faker::Lorem.paragraphs(1..10).join("\n\n")[0..1024], user_id: users.sample&.id)
    end
  rescue => e
    puts %(\e[31m#{e}\e[0m)
    next
  end
end
