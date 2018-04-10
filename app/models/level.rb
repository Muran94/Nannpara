# == Schema Information
#
# Table name: levels
#
#  id                        :integer          not null, primary key
#  level                     :integer
#  required_experience_point :integer
#  rank                      :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class Level < ApplicationRecord
    RANKS = [
        {level_range: 1...10, name: "ナンパ素人"},
        {level_range: 10...30, name: "ナンパ初心者"},
        {level_range: 30...50, name: "ナンパ中級者"},
        {level_range: 50...75, name: "ナンパ上級者"},
        {level_range: 75...100, name: "ナンパ超上級者"},
        {level_range: 100, name: "ナンパゴッド"}
    ]
end
