class CreateLevels < ActiveRecord::Migration[5.1]
  def change
    create_table :levels do |t|
      t.integer :required_experience_point
      t.string :rank

      t.timestamps
    end
  end
end
