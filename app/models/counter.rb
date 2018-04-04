# == Schema Information
#
# Table name: counters
#
#  id           :integer          not null, primary key
#  counter_type :string
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Counter < ApplicationRecord
  belongs_to :user

  COUNTER_TYPE_AVAILABLE_VALUES = %w(声かけ バンゲ 即).freeze
  validates :counter_type, inclusion: { in: COUNTER_TYPE_AVAILABLE_VALUES }
end
