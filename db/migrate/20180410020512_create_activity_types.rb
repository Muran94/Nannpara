class CreateActivityTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :activity_types do |t|
      t.string :name_ja
      t.string :name_en
      t.integer :experience_point, default: 0

      t.timestamps
    end
  end
end
