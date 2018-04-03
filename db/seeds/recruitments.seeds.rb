after :users do
  Faker::Config.locale = :ja

  maximum_title_length = Recruitment::MAXIMUM_TITLE_LENGTH
  maximum_description_length = Recruitment::MAXIMUM_DESCRIPTION_LENGTH
  maximum_venue_length = Recruitment::MAXIMUM_VENUE_LENGTH


  TITLE_SAMPLES = %w(
    今日の１９時から出撃予定！仲間募集中！
    新宿歌舞伎町でソロナンパします！５名募集中
    初心者です！よろしくお願いします！
    ソロで出撃しましょう！
    ストナン仲間募集
    ナンパを学んで人生をより良くしたい方必見！
    ストリートナンパ即ゲ目指して頑張りましょう！
    番ゲ50人達成まで帰れま10
  ).push(Faker::Lorem.characters(maximum_title_length)).push('１')
  VENUE_SAMPLES = %w(
    渋谷ハチ公前
    新宿歌舞伎町
    新橋
    池袋東口
    川崎).push(Faker::Lorem.characters(maximum_venue_length)).push('都')

  100.times do
    event_date = rand(-15..30).days.from_now
    closed = event_date < Date.today

    recruitment = Recruitment.new(
      title: TITLE_SAMPLES.sample,
      description: Faker::Lorem.paragraphs(rand(1..10)).join("\n\n")[0..maximum_description_length],
      prefecture_code: rand(1..47),
      venue: VENUE_SAMPLES.sample,
      event_date: event_date,
      user_id: User.all.to_a.sample.id,
      closed: closed,
      linked_with_kanto_nanpa_messageboard: false,
      kanto_nanpa_messageboard_delete_key: nil
    )
    recruitment.save(validate: false)
  end
end
