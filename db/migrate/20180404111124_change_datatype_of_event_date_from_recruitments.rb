class ChangeDatatypeOfEventDateFromRecruitments < ActiveRecord::Migration[5.1]
  def change
    change_column :recruitments, :event_date, :date
  end
end
