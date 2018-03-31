require 'rails_helper'

RSpec.describe 'DeleteImage', type: :system do
  let(:user) {create(:user)}

  context "正常系" do
    it "画像を削除できること" do
      # アカウントログイン
      login_as user, scope: :user

      # 自分のアカウントページに遷移
      visit profile_account_path user
      sleep 0.1

      find("#edit-image-link").click # 「プロフィール画像編集」ボタンをクリック
      sleep 0.1

      click_on "画像を削除"
      sleep 0.1

      expect(page).to have_content "プロフィール画像の削除が完了しました。"
    end
  end
end
