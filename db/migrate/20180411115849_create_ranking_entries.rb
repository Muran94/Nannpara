class CreateRankingEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :ranking_entries do |t|
      t.references :user, foreign_key: true
      t.references :ranking, foreign_key: true

      t.timestamps
    end
  end
end
