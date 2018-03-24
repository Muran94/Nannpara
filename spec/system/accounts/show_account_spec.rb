require 'rails_helper'

RSpec.describe 'ShowAccount', type: :system do
  let(:user) do
    create(
      :user,
      name: name,
      introduction: introduction,
      age: age,
      prefecture_code: prefecture_code,
      experience: experience
    )
  end
  let(:name) {"南原さん"}
  let(:introduction) {"ナンパ歴3年です！新宿でよく活動しています！よろしくお願いします！"}
  let(:age) {28}
  let(:prefecture_code) {13} # 東京都
  let(:experience) {"３年"}

  let(:other_user) {create(:user)}

  context "自分のアカウントページを確認" do
    it "アカウント情報が表示されており、自分にしか見えていないはずの項目が表示されていること" do
      # アカウントログイン
      login_as user, scope: :user

      # 自分のアカウントページに遷移
      visit profile_account_path user
      sleep 0.1

      # アカウント情報が表示されているか
      expect(page).to have_content name
      expect(page).to have_content introduction
      expect(page).to have_content "#{age}歳"
      expect(page).to have_content JpPrefecture::Prefecture.find(prefecture_code).name
      expect(page).to have_content experience

      expect(page).to have_css "#account-edit-link"

      expect(page).to have_css "#email-container"
      expect(page).to have_content user.email
      expect(page).to have_css "#edit-email-link"

      expect(page).to have_css "#password-container"
      expect(page).to have_css "#edit-password-link"

      expect(page).to have_css "#resign-account-link"
    end
  end

  context "他人のアカウントページを確認" do
    it "アカウント情報は表示されるが、アカウント編集リンクは表示されないこと" do
      # まずは未ログインユーザーが人のアカウントページを開いた時を想定
      # 他人のアカウントページに遷移
      visit profile_account_path user
      sleep 0.1

      # アカウント情報が表示されているか
      expect(page).to have_content name
      expect(page).to have_content introduction
      expect(page).to have_content "#{age}歳"
      expect(page).to have_content JpPrefecture::Prefecture.find(prefecture_code).name
      expect(page).to have_content experience

      expect(page).not_to have_css "#account-edit-link"

      expect(page).not_to have_css "#email-container"
      expect(page).not_to have_content user.email
      expect(page).not_to have_css "#edit-email-link"

      expect(page).not_to have_css "#password-container"
      expect(page).not_to have_css "#edit-password-link"
      expect(page).not_to have_css "#resign-account-link"

      # 次にログインユーザーが人のアカウントページを開いた時を想定
      login_as other_user, user: :scope
      # 他人のアカウントページに遷移
      visit profile_account_path user
      sleep 0.1

      # アカウント情報が表示されているか
      expect(page).to have_content name
      expect(page).to have_content introduction
      expect(page).to have_content "#{age}歳"
      expect(page).to have_content JpPrefecture::Prefecture.find(prefecture_code).name
      expect(page).to have_content experience

      expect(page).not_to have_css "#account-edit-link"

      expect(page).not_to have_css "#email-container"
      expect(page).not_to have_content user.email
      expect(page).not_to have_css "#edit-email-link"

      expect(page).not_to have_css "#password-container"
      expect(page).not_to have_css "#edit-password-link"
      expect(page).not_to have_css "#resign-account-link"
    end
  end
end
