# == Schema Information
#
# Table name: recruitments
#
#  id              :integer          not null, primary key
#  title           :string
#  description     :text
#  event_date      :datetime
#  venue           :string
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  prefecture_code :integer
#

require 'test_helper'

class RecruitmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
