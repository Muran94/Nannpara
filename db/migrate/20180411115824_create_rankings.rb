class CreateRankings < ActiveRecord::Migration[5.1]
  def change
    create_table :rankings do |t|
      t.string :name
      t.integer :ranking_type_id
      t.datetime :closed_at

      t.timestamps
    end
  end
end
