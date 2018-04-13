# == Schema Information
#
# Table name: rankings
#
#  id              :integer          not null, primary key
#  ranking_type_id :integer
#  start_at        :datetime
#  end_at          :datetime
#  closed_at       :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Ranking < ApplicationRecord
    belongs_to :ranking_type
    has_many :ranking_entries, dependent: :destroy
    has_many :users, through: :ranking_entries

    before_create :_set_start_at, :_set_end_at
    after_create :_set_announce_result_job

    validates :ranking_type_id,  uniqueness: { scope: [:start_at, :end_at]  }

    scope :hourly_activity_ranking, -> {where(ranking_type: RankingType.find_by_name_ja("毎時の活動ランキング"))}
    scope :daily_activity_ranking, -> {where(ranking_type: RankingType.find_by_name_ja("本日の活動ランキング"))}
    scope :monthly_activity_ranking, -> {where(ranking_type: RankingType.find_by_name_ja("今月の活動ランキング"))}
    scope :in_session, -> {where("start_at <= ?", Time.zone.now).where("end_at >= ?", Time.zone.now)} # 開催中のもの

    def self.create_monthly_activity_ranking(start_at=nil, end_at=nil)
        create(ranking_type: RankingType.find_by_name_ja("今月の活動ランキング"), start_at: start_at, end_at: end_at)
    end

    def self.create_daily_activity_ranking(start_at=nil, end_at=nil)
        create(ranking_type: RankingType.find_by_name_ja("本日の活動ランキング"), start_at: start_at, end_at: end_at)
    end

    def self.create_hourly_activity_ranking(start_at=nil, end_at=nil)
        create(ranking_type: RankingType.find_by_name_ja("毎時の活動ランキング"), start_at: start_at, end_at: end_at)
    end

    def close
        self.closed_at = Time.zone.now
        save(validate: false)
    end

    def entry(user)
        ranking_entries.create(user: user)
    end

    def in_session?
        start_at <= Time.zone.now && end_at  >= Time.zone.now
    end

    def possible_to_entry?(user)
        ranking_entries.where(user: user).blank?
    end

    # def award_top_three_rankers_a_prize
    #     case ranking_type.name_ja
    #     when "今月の活動ランキング"
    #         top_three_rankers.each {|}
    #     when "本日の活動ランキング"
    #     when "毎時の活動ランキング"
    #     end
    # end

    def top_three_rankers
        user_ranking.first(3)
    end

    def user_ranking(consider_writing_activity=true)
        if consider_writing_activity
            users.sort do |user_a, user_b|
                user_b.activities.obtained_points_in_particular_time(start_at, end_at) <=> 
                user_a.activities.obtained_points_in_particular_time(start_at, end_at)
            end
        else
            users.sort do |user_a, user_b|
                user_b.activities.without_writing.obtained_points_in_particular_time(start_at, end_at) <=> 
                user_a.activities.without_writing.obtained_points_in_particular_time(start_at, end_at)
            end
        end
    end

    private

    def _set_announce_result_job
        RankingResultAnnouncementJob.set(wait_until: end_at).perform_later(self)
        # RankingResultAnnouncementJob.set(wait_until: 5.seconds.from_now).perform_later(self)
    end

    def _set_start_at
        return if start_at.present?

        current_time = Time.zone.now
        case ranking_type.name_ja
        when "毎時の活動ランキング"
             self.start_at = current_time.beginning_of_hour
        when "本日の活動ランキング"
            self.start_at = current_time.beginning_of_day
        when "今月の活動ランキング"
             self.start_at = current_time.beginning_of_month
        end
    end

    def _set_end_at
        return if end_at.present?

        current_time = Time.zone.now
        case ranking_type.name_ja
        when "毎時の活動ランキング"
             self.end_at = current_time.end_of_hour
        when "本日の活動ランキング"
            self.end_at = current_time.end_of_day
        when "今月の活動ランキング"
             self.end_at = current_time.end_of_month
        end
    end
end
