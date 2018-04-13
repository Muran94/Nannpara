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

require 'rails_helper'

RSpec.describe RankingEntry, type: :model do
end
