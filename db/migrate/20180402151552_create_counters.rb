class CreateCounters < ActiveRecord::Migration[5.1]
  def change
    create_table :counters do |t|
      t.string :counter_type
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
