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
    it %(クライアントバリデーションに引っかかる) do
      # 会員登録ページに遷移
      visit new_user_registration_path

      # ユーザー名
      # 何も入力しないで登録
      click_button "登録"
      expect(page).to have_content "[ユーザー名] 入力必須です。"
      # ユーザー名の最大長を超えた長さで入力し登録
      fill_in "user[name]", with: "あ" * (User::MAXIMUM_NAME_LENGTH + 10)
      click_button "登録"
      expect(page).to have_content "[ユーザー名] 64文字以下で入力してください。"

      # メールアドレス
      # 何も入力しない登録
      click_button "登録"
      expect(page).to have_content "[メールアドレス] 入力必須です。"
      # 間違った形式で入力して登録
      fill_in "user[email]", with: "aa@@sample@.com"
      click_button "登録"
      expect(page).to have_content "[メールアドレス] 形式が正しくありません。"
      fill_in "user[email]", with: "" # 空にしないとこの後のテストが正常に機能しない

      # パスワード
      # 何も入力しない登録
      click_button "登録"
      expect(page).to have_content "[パスワード] 入力必須です。"
      # 6文字未満で入力
      fill_in "user[password]", with: "a" * 5
      click_button "登録"
      expect(page).to have_content "[パスワード] 6文字以上で入力してください。"
      # 129文字以上で入力
      fill_in "user[password]", with: "a" * 129
      click_button "登録"
      expect(page).to have_content "[パスワード] 128文字以下で入力してください。"
    end
  end
end
