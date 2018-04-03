require 'rails_helper'

RSpec.describe 'EditImage', type: :system do
  let(:user) { create(:user, image: nil) }

  context '正常系' do
    it '画像のアップロードに成功すること' do
      # アカウントログイン
      login_as user, scope: :user

      # 自分のアカウントページに遷移
      visit profile_account_path user
      sleep 0.1

      find('#edit-image-link').click # 「プロフィール画像編集」ボタンをクリック
      expect(page).not_to have_content '画像を削除'
      sleep 0.1

      attach_file 'user_image', File.join(Rails.root, 'spec/fixtures/image/sample_image.jpg')
      click_on '画像アップロード'
      sleep 0.1

      expect(page).to have_content 'プロフィール画像の変更が完了しました。'
    end
  end

  context '異常系' do
    it '画像のアップロードに失敗すること' do
      # アカウントログイン
      login_as user, scope: :user

      # 自分のアカウントページに遷移
      visit profile_account_path user
      sleep 0.1

      find('#edit-image-link').click # 「プロフィール画像編集」ボタンをクリック
      sleep 0.1

      attach_file 'user_image', File.join(Rails.root, 'spec/fixtures/image/large_sample_image.jpg')
      expect(page.driver.browser.switch_to.alert.text).to eq '画像のファイルサイズが大きすぎます。5MB以下の画像を選択してください。'
    end
  end
end
