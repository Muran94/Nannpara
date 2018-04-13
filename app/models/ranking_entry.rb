# == Schema Information
#
# Table name: ranking_entries
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  ranking_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RankingEntry < ApplicationRecord
  belongs_to :user
  belongs_to :ranking
end
