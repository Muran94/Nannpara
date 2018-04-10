class AddIndexToActivityTypes < ActiveRecord::Migration[5.1]
  def change
    add_index :activity_types, :name_ja
    add_index :activity_types, :name_en
  end
end
