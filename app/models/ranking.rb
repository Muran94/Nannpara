# == Schema Information
#
# Table name: rankings
#
#  id              :integer          not null, primary key
#  ranking_type_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Ranking < ApplicationRecord
    belongs_to :ranking_type
    has_many :ranking_entries
    has_many :users, through: :ranking_entries

    before_create :_set_ranking_name, :_set_start_at_and_end_at

    # validates :start_at, uniqueness: {} # 同じ種類で同じ開始時間のランキングが存在してはならない
    # validates :end_at, uniqueness: {} # 同じ種類で同じ終了時間のランキングが存在してはならない

    scope :hourly_activity_ranking, -> {where(ranking_type: RankingType.find_by_name_ja("毎時の活動ランキング"))}
    scope :daily_activity_ranking, -> {where(ranking_type: RankingType.find_by_name_ja("本日の活動ランキング"))}
    scope :monthly_activity_ranking, -> {where(ranking_type: RankingType.find_by_name_ja("今月の活動ランキング"))}
    scope :in_session, -> {where("start_at <= ?", Time.zone.now).where("end_at >= ?", Time.zone.now)} # 開催中のもの

    def self.create_monthly_activity_ranking
        create(ranking_type: RankingType.find_by_name_ja("今月の活動ランキング"))
    end

    def self.create_daily_activity_ranking
        create(ranking_type: RankingType.find_by_name_ja("本日の活動ランキング"))
    end

    def self.create_hourly_activity_ranking
        create(ranking_type: RankingType.find_by_name_ja("毎時の活動ランキング"))
    end

    def entry(user)
        ranking_entries.create(user: user)
    end

    def possible_to_entry?(user)
        ranking_entries.where(user: user).blank?
    end

    def top_three_rankers
        user_ranking.first(3)
    end

    def user_ranking
        users.sort do |user_a, user_b|
            user_b.activities.without_writing.from_particular_time_range(start_at, end_at).total_obtained_experience_point <=> 
            user_a.activities.without_writing.from_particular_time_range(start_at, end_at).total_obtained_experience_point
        end
    end

    private

    def _set_ranking_name
        current_time = Time.zone.now
        case ranking_type.name_ja
        when "毎時の活動ランキング" then self.name = "#{current_time.hour}時台のナンパ師活動ランキング"
        when "本日の活動ランキング" then self.name = "#{current_time.strftime("%Y年%m月%d日")}のナンパ師活動ランキング"
        when "今月の活動ランキング" then self.name = "#{current_time.strftime("%Y年%m月")}のナンパ師活動ランキング"
        else self.name = ranking_type.name_ja
        end
    end

    def _set_start_at_and_end_at(target_time=Time.zone.now)
        case ranking_type.name_ja
        when "毎時の活動ランキング"
             self.start_at = target_time.beginning_of_hour
             self.end_at = target_time.end_of_hour
        when "本日の活動ランキング"
            self.start_at = target_time.beginning_of_day
            self.end_at = target_time.end_of_day
        when "今月の活動ランキング"
             self.start_at = target_time.beginning_of_month
             self.end_at = target_time.end_of_month
        end
    end
end
