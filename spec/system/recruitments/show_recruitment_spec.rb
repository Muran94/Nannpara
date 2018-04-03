require 'rails_helper'

RSpec.describe 'ShowRecruitment', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:recruitment) { create(:recruitment, user: user) }
  let(:target_recruitment_path) { recruitment_path recruitment }

  context '募集詳細ページ閲覧テスト' do
    context '正常系' do
      it %(ログイン済みのオーナーには編集・削除ボタンが表示されている) do
        login_as user, scope: :user
        visit target_recruitment_path

        expect(page).to have_css '#recruitment-menu'
        find('#recruitment-menu').click
        expect(page).to have_css '#recruitment-edit-link'
        expect(page).to have_css '#recruitment-delete-link'
      end

      it %(オーナー以外には編集・削除ボタンが表示されていない) do
        login_as user, scope: :other_user
        visit target_recruitment_path

        expect(page).not_to have_css '#recruitment-menu'
      end

      it %(未ログインユーザーでも閲覧できる && 編集・削除ボタンが表示されていない) do
        visit target_recruitment_path

        expect(page).not_to have_css '#recruitment-menu'
      end

      it %(募集記事のプロフィール画像 または 募集オーナー名をクリックすればプロフィールにアクセスできる) do
        visit target_recruitment_path

        find('#recruitment-owner-profile-image').click
        expect(current_path).to eq profile_account_path user
        expect(page).to have_content user.name

        visit target_recruitment_path

        find('#recruitment-owner-profile-name').click
        expect(current_path).to eq profile_account_path user
        expect(page).to have_content user.name
      end
    end
  end
end
