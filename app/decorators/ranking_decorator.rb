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

    def archived_name
        case ranking_type.name_ja
        when "毎時の活動ランキング"
            "#{start_at.strftime("%m月%d日 %H")}時台のナンパ師活動ランキング"
        when "本日の活動ランキング"
            "(#{start_at.strftime("%m月%d日")})のデイリーナンパ師活動ランキング"
        when "今月の活動ランキング"
            "#{start_at.month}月のナンパ師活動ランキング"
        else
            ranking_type.name_ja
        end
    end
end
