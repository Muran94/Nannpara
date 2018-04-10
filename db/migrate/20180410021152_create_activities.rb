class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.references :activity_type, foreign_key: true
      t.integer :obtained_experience_point, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
