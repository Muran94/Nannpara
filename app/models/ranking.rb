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
    has_many :ranking_entries
end
