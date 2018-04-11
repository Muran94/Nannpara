class RankingsController < ApplicationController
  def index
    @hourly_activity_ranking = Ranking.where(activity_type_id: ActivityType.find_by_name_ja("毎時").id).order("created_at DESC").first
  end

  def show
  end
end
