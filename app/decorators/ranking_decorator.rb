module RankingDecorator
    def name
        case ranking_type.name_ja
        when "毎時の活動ランキング"
            "#{start_at.hour}時台のナンパ師活動ランキング"
        when "本日の活動ランキング"
            "本日のナンパ師活動ランキング"
        when "今月の活動ランキング"
            "今月のナンパ師活動ランキング"
        else
            ranking_type.name_ja
        end
    end
end
