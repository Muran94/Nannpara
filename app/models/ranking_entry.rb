class RankingEntry < ApplicationRecord
  belongs_to :user
  belongs_to :ranking
end
