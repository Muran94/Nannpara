class AddDirectMailToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :direct_mail, :boolean
  end
end
