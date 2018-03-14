class AddPrefectureCodeToRecruitments < ActiveRecord::Migration[5.1]
  def change
    add_column :recruitments, :prefecture_code, :integer
  end
end
