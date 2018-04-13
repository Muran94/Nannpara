class CreateRankings < ActiveRecord::Migration[5.1]
  def change
    create_table :rankings do |t|
      t.references :ranking_type, foreign_key: true
      t.datetime :start_at, index: true
      t.datetime :end_at, index: true
      t.datetime :closed_at, index: true

      t.timestamps
    end
  end
end
