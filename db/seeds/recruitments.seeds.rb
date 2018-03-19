after :users do
  Faker::Config.locale = :ja

  TITLE_SAMPLES = %w(
    今日の１９時から出撃予定！仲間募集中！
    新宿歌舞伎町でソロナンパします！５名募集中
    初心者です！よろしくお願いします！
    ソロで出撃しましょう！
    ストナン仲間募集
    ナンパを学んで人生をより良くしたい方必見！
    ストリートナンパ即ゲ目指して頑張りましょう！
    番ゲ50人達成まで帰れま10
  ).push(Faker::Lorem.characters(100)).push('１')
  VENUE_SAMPLES = %w(渋谷ハチ公前 新宿歌舞伎町 新橋 池袋東口 川崎).push(Faker::Lorem.characters(32)).push('都')

  200.times do
    Recruitment.create(
      title: TITLE_SAMPLES.sample,
      description: Faker::Lorem.paragraphs(rand(1..10)).join("\n\n")[0..5120],
      prefecture_code: rand(1..47),
      venue: VENUE_SAMPLES.sample,
      event_date: rand(1..30).days.from_now,
      user_id: User.all.to_a.sample.id
    )
  end
end