class AddIndexToRankingTypes < ActiveRecord::Migration[5.1]
  def change
    add_index :ranking_types, :name_en
    add_index :ranking_types, :name_ja
  end
end
