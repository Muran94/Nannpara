require 'rails_helper'

RSpec.describe 'ShowTweet', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:tweet) { create(:tweet, user: user) }

  context '自分のつぶやきの場合' do
    it 'ドロップダウンボタンが表示されており、削除ボタンをクリックできること' do
      login_as user, scope: :user
      visit tweet_path(tweet)

      # つぶやきのユーザー名と内容が表示されているか確認
      expect(page).to have_content tweet.user.name
      expect(page).to have_content tweet.content

      # ドロップダウンボタンが表示されており、削除ができること
      expect(page).to have_css '#tweet-menu-dropdown'
      find('#tweet-menu-dropdown').click # ドロップダウンメニューをクリック
      find('#tweet-delete-link').click # 削除ボタンをクリック
      page.driver.browser.switch_to.alert.accept # コンファームダイアログのOKボタンをクリック
      sleep 0.1

      expect(page).to have_content 'つぶやきの削除が完了しました。'
    end
  end

  context '他人のつぶやきの場合' do
    context 'ログインユーザーの場合' do
      it 'ドロップダウンボタンが表示されていないこと' do
        login_as other_user, scope: :user
        visit tweet_path(tweet)

        # つぶやきのユーザー名と内容が表示されているか確認
        expect(page).to have_content tweet.user.name
        expect(page).to have_content tweet.content

        # ドロップダウンボタンが表示されており、削除ができること
        expect(page).not_to have_css '#tweet-menu-dropdown'
      end
    end
    context '未ログインユーザーの場合' do
      it 'ドロップダウンボタンが表示されていないこと' do
        visit tweet_path(tweet)

        # つぶやきのユーザー名と内容が表示されているか確認
        expect(page).to have_content tweet.user.name
        expect(page).to have_content tweet.content

        # ドロップダウンボタンが表示されており、削除ができること
        expect(page).not_to have_css '#tweet-menu-dropdown'
      end
    end
  end
end
