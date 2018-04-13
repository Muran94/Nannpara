class CreateRankingTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :ranking_types do |t|
      t.string :name_en
      t.string :name_ja

      t.timestamps
    end
  end
end
