class AddIndexToLevels < ActiveRecord::Migration[5.1]
  def change
    add_index :levels, :required_experience_point
  end
end
