Faker::Config.locale = :ja

ActivityType.create(name_en: "post_recruitment_article", name_ja: "募集記事の投稿", experience_point: 3)
ActivityType.create(name_en: "post_blog_article", name_ja: "ブログ記事の投稿", experience_point: 3)
ActivityType.create(name_en: "talk", name_ja: "声かけ", experience_point: 2)
ActivityType.create(name_en: "get_phone_number", name_ja: "番ゲ", experience_point: 5)
ActivityType.create(name_en: "date", name_ja: "連れ出し", experience_point: 10)
ActivityType.create(name_en: "instant_sex", name_ja: "即", experience_point: 100)
ActivityType.create(name_en: "sex_on_first_date", name_ja: "準即", experience_point: 75)
ActivityType.create(name_en: "sex_on_second_date", name_ja: "準々即", experience_point: 50)
