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
  let(:other_user) { create(:user) }

  let(:name) { 'ナンパ仙人' }
  let(:introduction) { 'ナンパ歴3年です！新宿でよく活動しています！よろしくお願いします！' }
  let(:age) { 28 }
  let(:prefecture_code) { 13 } # 東京都
  let(:experience) { '３年' }

  let!(:recruitment) { create(:recruitment, user: user) }
  let!(:blog_article) { create(:blog_article, user: user) }

  context '自分のアカウントページを確認' do
    it 'アカウント情報が表示されており、自分にしか見えていないはずの項目が表示されていること' do
      # アカウントログイン
      login_as user, scope: :user

      # 自分のアカウントページに遷移
      visit profile_account_path user
      sleep 0.1

      # タブの表示確認
      within '#account-tab' do
        click_link '募集'
        sleep 0.1
      end
      expect(current_path).to eq recruitments_account_path user.id
      expect(page).to have_content recruitment.title

      within '#account-tab' do
        click_link 'ブログ'
        sleep 0.1
      end
      expect(current_path).to eq blog_articles_account_path user.id
      expect(page).to have_content blog_article.title

      within '#account-tab' do
        click_link "ランキング"
        sleep 0.1
      end
      expect(current_path).to eq rankings_account_path user.id
      expect(page).to have_content "エントリー済のランキング"

      within '#account-tab' do
        click_link 'プロフィール'
        sleep 0.1
      end

      # アカウント情報が表示されているか
      expect(page).to have_content name
      expect(page).to have_content introduction
      expect(page).to have_content "#{age}歳"
      expect(page).to have_content JpPrefecture::Prefecture.find(prefecture_code).name
      expect(page).to have_content experience

      expect(page).to have_css '#edit-image-link' # プロフィール画像編集ボタン

      expect(page).to have_css '#account-edit-link'

      expect(page).to have_css '#email-container'
      expect(page).to have_content user.email
      expect(page).to have_css '#edit-email-link'

      expect(page).to have_css '#password-container'
      expect(page).to have_css '#edit-password-link'

      expect(page).to have_css '#resign-account-link'
    end
  end

  context '他人のアカウントページを確認' do
    it 'アカウント情報は表示されるが、アカウント編集リンクは表示されないこと' do
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

      expect(page).not_to have_css '#edit-image-link' # プロフィール画像編集ボタン

      expect(page).not_to have_css '#account-edit-link'

      expect(page).not_to have_css '#email-container'
      expect(page).not_to have_content user.email
      expect(page).not_to have_css '#edit-email-link'

      expect(page).not_to have_css '#password-container'
      expect(page).not_to have_css '#edit-password-link'
      expect(page).not_to have_css '#resign-account-link'

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

      expect(page).not_to have_css '#account-edit-link'

      expect(page).not_to have_css '#email-container'
      expect(page).not_to have_content user.email
      expect(page).not_to have_css '#edit-email-link'

      expect(page).not_to have_css '#password-container'
      expect(page).not_to have_css '#edit-password-link'
      expect(page).not_to have_css '#resign-account-link'
    end
  end
end
