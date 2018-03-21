require 'rails_helper'

RSpec.describe 'CreateRegistration', type: :system do
  context %(正常系) do
    it %(会員登録テスト) do
      # ユーザー数が0であることを確認
      expect(User.count).to eq 0

      # 会員登録ページに遷移
      visit new_user_registration_path

      # フォームを入力し登録
      fill_in "user[name]", with: "ゲーテ" # ユーザー名
      fill_in "user[email]", with: "goethe@gmail.com" # メールアドレス
      fill_in "user[password]", with: "password" # パスワード
      click_button "登録"
      sleep 0.1

      # ルートページに遷移されていることとflashメッセージを確認
      expect(current_path).to eq root_path
      expect(page).to have_content "アカウント登録が完了しました。"

      # ユーザーが登録されていることを確認
      user = User.first
      expect(user.name).to eq "ゲーテ"
    end
  end

  context %(異常系) do

  end
end
