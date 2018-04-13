namespace :ranking do
    # 次の月の「今月の活動ランキング」を作成
    task create_monthly_activity_ranking: :environment do
        # time = Time.zone.now + 1.month
        time = Time.zone.now
        # @TODO jobの設定。end_atの時間が来たら、トップランカーに経験値を付与 + 通知
        Ranking.create_monthly_activity_ranking(time.beginning_of_month, time.end_of_month)
    end

    # 次の日の「本日の活動ランキング」を作成
    task create_daily_activity_ranking: :environment do
        # time = Time.zone.now + 1.day 
        time = Time.zone.now
        # @TODO jobの設定。end_atの時間が来たら、トップランカーに経験値を付与 + 通知
        Ranking.create_daily_activity_ranking(time.beginning_of_day, time.end_of_day)
    end

    # 毎日お昼の3時にcronで実行
    # 次の日の24時間分の「毎時の活動ランキング」を作成
    task create_hourly_activity_ranking_set: :environment do
        # time = (Time.zone.now + 1.day).beginning_of_day
        time = Time.zone.now.beginning_of_day
        24.times do
            ranking = Ranking.create_hourly_activity_ranking(time.beginning_of_hour, time.end_of_hour)
            time += 1.hour
            sleep 1
        end
    end
end
