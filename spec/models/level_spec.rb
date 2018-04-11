# == Schema Information
#
# Table name: levels
#
#  id                        :integer          not null, primary key
#  required_experience_point :integer
#  rank                      :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

require 'rails_helper'

RSpec.describe Level, type: :model do
end
