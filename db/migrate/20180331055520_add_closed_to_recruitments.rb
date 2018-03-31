class AddClosedToRecruitments < ActiveRecord::Migration[5.1]
  def change
    add_column :recruitments, :closed, :boolean, default: :false
  end
end
