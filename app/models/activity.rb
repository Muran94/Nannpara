# == Schema Information
#
# Table name: activities
#
#  id                        :integer          not null, primary key
#  activity_type_id          :integer
#  obtained_experience_point :integer          default(0)
#  user_id                   :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class Activity < ApplicationRecord
  belongs_to :activity_type
  belongs_to :user

  before_create :_set_obtained_experience_point
  after_create :_update_users_experience_point, :_entry_activity_rankings
  after_destroy :_update_users_experience_point

  validates :activity_type_id, inclusion: {in: ActivityType.pluck(:id)}

  scope :without_writing, -> {where.not(activity_type_id: [1, 2])} # 募集記事作成やブログ記事作成をのぞいた活動
  scope :from_particular_time_range, -> (start_at, end_at) {where("created_at >= ?", start_at).where("created_at <= ?", end_at)}
  scope :total_obtained_experience_point, -> {sum(:obtained_experience_point)} 

  private

  def _entry_activity_rankings
    _entry_hourly_activity_ranking
    _entry_daily_activity_ranking
    _entry_monthly_activity_ranking
  end

  def _entry_hourly_activity_ranking
    return if %w[募集記事の投稿 ブログ記事の投稿].include?(activity_type.name_ja) # 募集記事の投稿、ブログ記事の投稿ではエントリーできない

    hourly_activity_ranking = Ranking.hourly_activity_ranking.in_session.first # 現在開催中の毎時ランキング
    if hourly_activity_ranking.present? && hourly_activity_ranking.possible_to_entry?(user)
      hourly_activity_ranking.entry(user)
    end
  end

  def _entry_daily_activity_ranking
    daily_activity_ranking = Ranking.daily_activity_ranking.in_session.first # 現在開催中の日時ランキング
    if daily_activity_ranking.present? && daily_activity_ranking.possible_to_entry?(user)
      daily_activity_ranking.entry(user)
    end
  end

  def _entry_monthly_activity_ranking
    monthly_activity_ranking = Ranking.monthly_activity_ranking.in_session.first # 現在開催中の日時ランキング
    if monthly_activity_ranking.present? && monthly_activity_ranking.possible_to_entry?(user)
      monthly_activity_ranking.entry(user)
    end
  end

  def _set_obtained_experience_point
    self.obtained_experience_point = activity_type.experience_point
  end

  def _update_users_experience_point
    user.experience_point = user.activities.sum(:obtained_experience_point)
    user.save(validate: false)
  end
end
