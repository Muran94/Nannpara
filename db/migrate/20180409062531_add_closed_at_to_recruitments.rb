class AddClosedAtToRecruitments < ActiveRecord::Migration[5.1]
  def change
    add_column :recruitments, :closed_at, :datetime
    add_index :recruitments, :closed_at
  end
end
