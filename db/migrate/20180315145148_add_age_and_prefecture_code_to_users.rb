class AddAgeAndPrefectureCodeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :age, :integer
    add_column :users, :prefecture_code, :integer
  end
end
