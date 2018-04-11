# == Schema Information
#
# Table name: rankings
#
#  id              :integer          not null, primary key
#  ranking_type_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Ranking, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
