# == Schema Information
#
# Table name: ranking_types
#
#  id         :integer          not null, primary key
#  name_en    :string
#  name_ja    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe RankingType, type: :model do
end
