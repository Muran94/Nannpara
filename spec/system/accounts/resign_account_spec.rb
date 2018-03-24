require 'rails_helper'

RSpec.describe 'ResignAccount', type: :system do
  let(:user) {create(:user)}

  context "自分のアカウントページを確認" do
    it "アカウント情報が表示されており、自分にしか見えていないはずの項目が表示されていること" do
      # アカウントログイン
      login_as user, scope: :user

      # 自分のアカウントページに遷移
      visit profile_account_path user
      sleep 0.1

      # 退会ボタンをクリック
      find("#resign-account-link").click
      page.driver.browser.switch_to.alert.accept # confirmダイアログのOKボタンをクリック

      # トップページにん遷移し、flashメッセージが表示される
      expect(current_path).to eq root_path
      expect(page).to have_content "アカウントを削除しました。またのご利用をお待ちしております。"

      # ユーザー数が0になっている
      expect(User.count).to eq 0
    end
  end
end
