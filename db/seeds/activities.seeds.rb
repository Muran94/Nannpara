after :users, :levels, :activity_types do
    Faker::Config.locale = :ja

    2000.times do
        Activity.create(user_id: User.all.pluck(:id).sample, activity_type_id: ActivityType.all.pluck(:id).sample)
    end
end