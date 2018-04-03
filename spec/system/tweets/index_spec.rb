require 'rails_helper'

RSpec.describe "Index", type: :system do
  context "つぶやきがある場合" do
    it "つぶやき一覧が表示されること" do
      create_list(:tweet, 3)
      visit tweets_path
      expect(page).not_to have_content "まだつぶやきがありません・・・"
    end
  end

  context "つぶやきがまだない場合" do
    it "「まだつぶやきがありません」と表示されること" do
      visit tweets_path
      expect(page).to have_content "まだつぶやきがありません・・・"
    end
  end
end
