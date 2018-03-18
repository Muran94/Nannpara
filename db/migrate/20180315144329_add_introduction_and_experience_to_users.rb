class AddIntroductionAndExperienceToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :introduction, :text
    add_column :users, :experience, :string
  end
end
