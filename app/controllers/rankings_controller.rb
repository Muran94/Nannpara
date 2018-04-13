class RankingsController < ApplicationController
  def index
    @hourly_activity_ranking = Ranking.hourly_activity_ranking.in_session.first
    if @hourly_activity_ranking.present?
      @hourly_activity_ranking_entry_number = @hourly_activity_ranking.users.count
      @hourly_activity_top_three_users = @hourly_activity_ranking.top_three_rankers
    end

    @daily_activity_ranking = Ranking.daily_activity_ranking.in_session.first
    if @daily_activity_ranking.present?
      @daily_activity_ranking_entry_number = @daily_activity_ranking.users.count
      @daily_activity_top_three_users = @daily_activity_ranking.top_three_rankers
    end

    @monthly_activity_ranking = Ranking.monthly_activity_ranking.in_session.first
    if @monthly_activity_ranking.present?
      @monthly_activity_ranking_entry_number = @monthly_activity_ranking.users.count
      @monthly_activity_top_three_users = @monthly_activity_ranking.top_three_rankers
    end
  end

  def show
    @ranking = Ranking.find(params[:id])
    @ranking_entry_users = @ranking.user_ranking
  end
end
