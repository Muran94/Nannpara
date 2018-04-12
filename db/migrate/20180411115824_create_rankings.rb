class CreateRankings < ActiveRecord::Migration[5.1]
  def change
    create_table :rankings do |t|
      t.references :ranking_type, foreign_key: true
      t.string :name
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
