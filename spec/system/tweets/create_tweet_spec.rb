require 'rails_helper'

RSpec.describe 'CreateTweet', type: :system do
  let(:user) { create(:user) }

  context 'ログインユーザーの場合' do
    context '正常系' do
      it '正常につぶやけること' do
        login_as user, scope: :user
        visit tweets_path
        find('#bottom-fixed-button').click # 右下の「つぶやく」ボタンをクリックし、つぶやきフォーム画面に遷移
        sleep 0.1

        # フォームを入力して・・・
        fill_in 'tweet[content]', with: 'ああ、疲れた。どうしても地蔵してしまうな・・・'
        click_button 'つぶやく'

        # つぶやきが反映されていることと、flashが表示されていること
        expect(page).to have_content 'つぶやきが完了しました。'
        expect(page).to have_content Tweet.first.content
      end
    end

    context '異常系' do
      it '文字数制限をオーバーした時はクライアントバリデーションに引っかかること' do
        login_as user, scope: :user
        visit tweets_path
        find('#bottom-fixed-button').click # 右下の「つぶやく」ボタンをクリックし、つぶやきフォーム画面に遷移
        sleep 0.1

        # フォームを入力して・・・
        fill_in 'tweet[content]', with: 'あ' * (Tweet::MAXIMUM_CONTENT_LENGTH + 1)
        click_button 'つぶやく'

        # クライアントバリデーションのメッセージが表示されていること
        expect(page).to have_content '140文字以下で入力してください。'
      end
    end
  end

  context '未ログインユーザーの場合' do
    it '文字数制限をオーバーした時はクライアントバリデーションに引っかかること' do
      visit tweets_path
      find('#bottom-fixed-button').click # 右下の「つぶやく」ボタンをクリックし、つぶやきフォーム画面に遷移
      sleep 0.1

      # ユーザーログイン画面に遷移されていること
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
    end
  end
end
