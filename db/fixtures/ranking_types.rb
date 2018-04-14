require "csv"

ranking_type_seed_csv = CSV.table("db/fixtures/seed_csv/ranking_types.csv")

ranking_type_seed_csv.each do |row|
    RankingType.seed do |s|
        s.id = row[:id]
        s.name_en = row[:name_en]
        s.name_ja = row[:name_ja]
    end
end