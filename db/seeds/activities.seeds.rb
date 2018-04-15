after :users do
    Faker::Config.locale = :ja

    200.times do
        Activity.create(user_id: User.all.pluck(:id).sample, activity_type_id: ActivityType.where(id: [1, 2, 3, 4, 5, 6, 7, 8]).pluck(:id).sample)
    end
end