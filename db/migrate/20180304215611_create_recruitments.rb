class CreateRecruitments < ActiveRecord::Migration[5.1]
  def change
    create_table :recruitments do |t|
      t.string :title
      t.text :description
      t.datetime :event_date
      t.string :venue
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
