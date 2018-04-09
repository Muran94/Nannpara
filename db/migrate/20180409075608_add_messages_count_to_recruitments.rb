class AddMessagesCountToRecruitments < ActiveRecord::Migration[5.1]
  def self.up
    add_column :recruitments, :messages_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :recruitments, :messages_count
  end
end
