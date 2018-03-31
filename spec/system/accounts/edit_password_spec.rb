require 'rails_helper'

RSpec.describe 'EditPassword', type: :system do
  let(:user) {create(:user, password: before_password, password_confirmation: before_password)}
  let(:before_password) {"before_password"}
  let(:after_password) {"after_password"}

  context "正常系" do
    it "パスワードを正常に変更できること" do
      # アカウントログイン
      login_as user, scope: :user

      # 自分のアカウントページに遷移
      visit profile_account_path user
      sleep 0.1

      find("#edit-password-link").click # パスワードの「変更」ボタンをクリック
      sleep 0.1

      # フォームを埋めていって
      fill_in "user[current_password]", with: before_password
      fill_in "user[password]", with: after_password
      fill_in "user[password_confirmation]", with: after_password
      click_button "変更"
      sleep 0.1

      # アカウントページに遷移し、flashメッセージが表示されている
      expect(current_path).to eq profile_account_path user
      expect(page).to have_content "パスワード変更が完了しました。"
    end
  end

  context "異常系" do
    it "バリデーションに引っかかること" do
      # アカウントログイン
      login_as user, scope: :user

      # 自分のアカウントページに遷移
      visit profile_account_path user
      sleep 0.1

      find("#edit-password-link").click # パスワードの「変更」ボタンをクリック
      sleep 0.1

      # フォームを埋めていって
      fill_in "user[current_password]", with: before_password
      fill_in "user[password]", with: after_password
      fill_in "user[password_confirmation]", with: "aaaa"
      click_button "変更"
      sleep 0.1

      # flashメッセージが表示されている
      expect(page).to have_content "パスワード変更に失敗しました。"

      # クライアントバリデーションの動作チェック
      # 何も入力していない状態で変更ボタンをクリック
      click_button "変更"
      expect(page).to have_content "[パスワード] 入力必須です。"
      expect(page).to have_content "[現在のパスワード] 入力必須です。"
      expect(page).to have_content "[新しいパスワード（再入力）] 入力必須です。"
      # まずはuser[password]の長さによるバリデーションチェック
      # 6文字未満と、129文字以上はアウト
      fill_in "user[password]", with: "a" * 5
      click_button "変更"
      expect(page).to have_content "[パスワード] 6文字以上で入力してください。"
      fill_in "user[password]", with: "a" * 129
      click_button "変更"
      expect(page).to have_content "[パスワード] 128文字以下で入力してください。"
    end
  end
end
