# == Schema Information
#
# Table name: activity_types
#
#  id               :integer          not null, primary key
#  name_ja          :string
#  name_en          :string
#  experience_point :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe ActivityType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
