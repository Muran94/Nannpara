class DropCounterTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :counters
  end
end
