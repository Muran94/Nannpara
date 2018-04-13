Faker::Config.locale = :ja

# 執筆系
ActivityType.create(name_en: "post_recruitment_article", name_ja: "募集記事の投稿", experience_point: 3)
ActivityType.create(name_en: "post_blog_article", name_ja: "ブログ記事の投稿", experience_point: 3)

# リアルでのナンパ活動系
ActivityType.create(name_en: "talk", name_ja: "声かけ", experience_point: 3)
ActivityType.create(name_en: "get_phone_number", name_ja: "番ゲ", experience_point: 7)
ActivityType.create(name_en: "date", name_ja: "連れ出し", experience_point: 25)
ActivityType.create(name_en: "instant_sex", name_ja: "即", experience_point: 100)
ActivityType.create(name_en: "sex_on_first_date", name_ja: "準即", experience_point: 75)
ActivityType.create(name_en: "sex_on_second_date", name_ja: "準々即", experience_point: 50)

# ランキング賞系
# 「毎時の活動ランキング」系
ActivityType.create(name_en: "hourly_activity_ranking_champion", name_ja: "毎時の活動ランキング優勝", experience_point: 20)
ActivityType.create(name_en: "hourly_activity_ranking_second_place", name_ja: "毎時の活動ランキング準優勝", experience_point: 15)
ActivityType.create(name_en: "hourly_activity_ranking_third_place", name_ja: "毎時の活動ランキング3位", experience_point: 10)
# 「本日の活動ランキング」系
ActivityType.create(name_en: "daily_activity_ranking_champion", name_ja: "本日の活動ランキング優勝", experience_point: 50)
ActivityType.create(name_en: "daily_activity_ranking_second_place", name_ja: "本日の活動ランキング準優勝", experience_point: 40)
ActivityType.create(name_en: "daily_activity_ranking_third_place", name_ja: "本日の活動ランキング3位", experience_point: 30)
# 「今月の活動ランキング」系
ActivityType.create(name_en: "monthly_activity_ranking_champion", name_ja: "今月の活動ランキング優勝", experience_point: 300)
ActivityType.create(name_en: "monthly_activity_ranking_second_place", name_ja: "今月の活動ランキング準優勝", experience_point: 200)
ActivityType.create(name_en: "monthly_activity_ranking_third_place", name_ja: "今月の活動ランキング3位", experience_point: 100)
