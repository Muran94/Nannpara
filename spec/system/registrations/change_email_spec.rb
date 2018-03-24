require 'rails_helper'

RSpec.describe 'CreateRegistration', type: :system do
  let(:user) {create(:user, email: before_email)}

  let(:before_email) {"before@sample.com"}
  let(:after_email) {"after@sample.com"}

  before do
    # ログイン
    login_as user, scope: :user

    # メールアドレス変更画面に遷移
    visit edit_user_registration_path
    sleep 0.1

    # 現在のメールアドレスが表示されていること
    expect(page).to have_content before_email
  end

  context %(正常系) do
    it %(会員登録テスト) do
      # 新しいメールアドレスを入力して変更ボタンをクリック
      fill_in "user[email]", with: after_email
      click_button "変更"
      sleep 0.1

      # トップページに遷移し、適切なフラッシュメッセージが表示されている
      expect(current_path).to eq root_path
      expect(page).to have_content "アカウント情報を変更しました。"

      # ユーザーのメールアドレスが変更されている
      user.reload
      expect(user.email).to eq after_email
    end
  end

  context %(異常系) do
    it %(クライアントバリデーションに引っかかる) do
      visit edit_user_registration_path
      sleep 0.1

      # メールアドレスのフォームを埋めずにそのまま変更ボタンをクリック
      click_button "変更"
      expect(page).to have_content "[メールアドレス] 入力必須です。"

      # 不正な形式のメールアドレスを入力し変更ボタンをクリック
      fill_in "user[email]", with: "sample@sample@gmail.com@sample"
      click_button "変更"
      expect(page).to have_content "[メールアドレス] 形式が正しくありません。"
    end
  end
end
