class RemoveVenueFromRecruitment < ActiveRecord::Migration[5.1]
  def change
    remove_column :recruitments, :venue, :string
  end
end
