class AddIndexToCounters < ActiveRecord::Migration[5.1]
  def change
    add_index :counters, :counter_type
  end
end
