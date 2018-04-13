class RankingResultAnnouncementJob < ApplicationJob
  queue_as :default

  def perform(ranking)
    ranking.close
  end
end
