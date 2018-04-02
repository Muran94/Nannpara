class AddLinkedWithKantoNanpaMessageboardAndKantoNanpaMessageboardDeleteKeyToRecruitments < ActiveRecord::Migration[5.1]
  def change
    add_column :recruitments, :linked_with_kanto_nanpa_messageboard, :boolean
    add_column :recruitments, :kanto_nanpa_messageboard_delete_key, :string
  end
end
