require 'rails_helper'

RSpec.describe 'EditPassword', type: :system do
  let(:user) {create(:user, :without_profile)}
  let(:introduction) {"ナンパ初心者です！よろしくおねがいいたします！"}
  let(:age) {"24"}
  let(:prefecture) {"東京都"}
  let(:experience) {"3ヶ月"}

  context "自分のアカウントページを確認" do
    context "正常系" do
      it "プロフィール情報を正常に変更できること" do
        # アカウントログイン
        login_as user, scope: :user

        # 自分のアカウントページに遷移
        visit profile_account_path user
        sleep 0.1

        find("#account-edit-link").click # プロフィールの「編集」ボタンをクリック
        sleep 0.1

        # フォームを埋めていって
        attach_file "プロフィール画像", File.join(Rails.root, 'spec/fixtures/image/sample_image.jpg')
        fill_in "user[introduction]", with: introduction
        select age, from: "user[age]"
        select prefecture, from: "user[prefecture_code]"
        fill_in "user[experience]", with: experience
        click_button "プロフィール更新"
        sleep 0.1

        # アカウントページに遷移し、flashメッセージが表示されていること
        expect(current_path).to eq profile_account_path user
        expect(page).to have_content "プロフィール更新が完了しました。"

        # userのプロフィールが更新されていること
        user.reload
        expect(user.image).not_to eq nil
        expect(user.introduction).to eq introduction
        expect(user.age).to eq age.to_i
        expect(user.prefecture_code).to eq JpPrefecture::Prefecture.find(name: prefecture).code
        expect(user.experience).to eq experience
      end
    end

    context "異常系" do
      it "バリデーションに引っかかること" do
        # アカウントログイン
        login_as user, scope: :user

        # 自分のアカウントページに遷移
        visit profile_account_path user
        sleep 0.1

        find("#account-edit-link").click # プロフィールの「編集」ボタンをクリック
        sleep 0.1

        # クライアントバリデーション検証
        fill_in "user[name]", with: ""
        click_button "プロフィール更新"
        expect(page).to have_content "[ユーザー名] 入力必須です。"
        fill_in "user[name]", with: "あ" * (User::MAXIMUM_NAME_LENGTH + 1)
        click_button "プロフィール更新"
        expect(page).to have_content "[ユーザー名] 64文字以下で入力してください。"

        fill_in "user[introduction]", with: "あ" * (User::MAXIMUM_INTRODUCTION_LENGTH + 1)
        click_button "プロフィール更新"
        expect(page).to have_content "[自己紹介文] 5120文字以下で入力してください。"

        fill_in "user[experience]", with: "あ" * (User::MAXIMUM_EXPERIENCE_LENGTH + 1)
        click_button "プロフィール更新"
        expect(page).to have_content "[ナンパ歴] 32文字以下で入力してください。"
      end
    end
  end
end
