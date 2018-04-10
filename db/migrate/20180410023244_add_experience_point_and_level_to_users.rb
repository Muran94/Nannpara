class AddExperiencePointAndLevelToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :experience_point, :integer, default: 0
    add_column :users, :level_id, :integer, default: 1
  end
end
