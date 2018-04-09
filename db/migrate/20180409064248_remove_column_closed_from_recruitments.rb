class RemoveColumnClosedFromRecruitments < ActiveRecord::Migration[5.1]
  def change
    remove_index :recruitments, :closed
    remove_column :recruitments, :closed, :boolean
  end
end
