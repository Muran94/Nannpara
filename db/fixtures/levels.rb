required_experience_point = 0
experience_point_required_to_level_up = 0

1.upto(100) do |level|
    case level
        when Level::RANKS[0][:level_range] then rank = Level::RANKS[0][:name] # ナンパ素人
        when Level::RANKS[1][:level_range] then rank = Level::RANKS[1][:name] # ナンパ初心者
        when Level::RANKS[2][:level_range] then rank = Level::RANKS[2][:name] # ナンパ中級者
        when Level::RANKS[3][:level_range] then rank = Level::RANKS[3][:name] # ナンパ上級者
        when Level::RANKS[4][:level_range] then rank = Level::RANKS[4][:name] # ナンパ超上級者
        when Level::RANKS[5][:level_range] then rank = Level::RANKS[5][:name] # ナンパゴッド
    end

    Level.seed do |s|
        s.id = level
        s.required_experience_point = required_experience_point
        s.rank = rank
    end
    
    experience_point_required_to_level_up += 3
    required_experience_point += experience_point_required_to_level_up
end