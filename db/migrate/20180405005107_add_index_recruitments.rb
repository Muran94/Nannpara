class AddIndexRecruitments < ActiveRecord::Migration[5.1]
  def change
    add_index :recruitments, :event_date
    add_index :recruitments, :prefecture_code
    add_index :recruitments, :closed
  end
end
