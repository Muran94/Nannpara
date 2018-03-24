require 'rails_helper'

RSpec.describe 'CreateMessage', type: :system do
  let(:user) {create(:user)}
  let(:recruitment) {create(:recruitment)}

  context "正常系" do
    let(:message_text) {"よろしくお願いいたします！"}

    it %(ログインユーザーはメッセージを送信できる) do
      # 募集記事に遷移
      login_as user, scope: :user
      visit recruitment_path recruitment

      # メッセージを送信
      fill_in "message[message]", with: message_text
      click_button "メッセージ送信"
      sleep 0.1

      expect(page).to have_content message_text
    end

    it %(未ログインユーザーはメッセージを送信できる) do
      # 募集記事に遷移
      visit recruitment_path recruitment

      # メッセージを送信
      fill_in "message[message]", with: message_text
      click_button "メッセージ送信"
      sleep 0.1

      expect(page).to have_content message_text
    end
  end

  context "異常系" do
    it %(空 や 1025文字以上入力した場合はバリデーションに引っかかる) do
      # 募集記事に遷移
      visit recruitment_path recruitment
      sleep 0.1

      # 空のままメッセージを送信
      click_button "メッセージ送信"
      expect(page).to have_content "入力必須です。"

      fill_in "message[message]", with: "あ" * 1025
      click_button "メッセージ送信"
      expect(page).to have_content "1024文字以下で入力してください。"
    end
  end
end
