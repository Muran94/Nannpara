class CreateRankings < ActiveRecord::Migration[5.1]
  def change
    create_table :rankings do |t|
      t.integer :ranking_type_id

      t.timestamps
    end
  end
end
