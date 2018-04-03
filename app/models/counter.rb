class Counter < ApplicationRecord
  belongs_to :user

  COUNTER_TYPE_AVAILABLE_VALUES = %w(声かけ バンゲ 即).freeze
  validates :counter_type, inclusion: { in: COUNTER_TYPE_AVAILABLE_VALUES }
end
