require "csv"

activity_type_seed_csv = CSV.table("db/fixtures/seed_csv/activity_types.csv")

activity_type_seed_csv.each do |row|
    ActivityType.seed do |s|
        s.id = row[:id]
        s.name_en = row[:name_en]
        s.name_ja = row[:name_ja]
        s.experience_point = row[:experience_point]
    end
end