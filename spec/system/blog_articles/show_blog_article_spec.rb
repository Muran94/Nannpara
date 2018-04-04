require 'rails_helper'

RSpec.describe 'ShowBlogArticle', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:blog_article) { create(:blog_article, user: user) }

  context '自分のブログ記事を閲覧する場合' do
    before do
      login_as user, scope: :user
      visit blog_article_path blog_article
    end

    it 'コンテンツの中身が正常に表示されていることと、編集・削除メニューを確認できること' do
      # コンテンツの中身が表示されていることを確認
      expect(page).to have_content blog_article.title
      expect(page).to have_content blog_article.content

      # 「編集」と「削除」ボタンを表示するためにドロップダウンボタンをクリック
      find('#blog-article-menu').click
      expect(page).to have_css '#blog-article-edit-link' # 「編集」ボタンが表示されている
      expect(page).to have_css '#blog-article-delete-link' # 「削除」ボタンが表示されている
    end
  end

  context '他人のブログ記事を閲覧する場合' do
    context 'ログインユーザー' do
      before do
        login_as other_user, scope: :user
        visit blog_article_path blog_article
      end

      it 'コンテンツの中身は正常に表示されているが、編集・削除ボタンを表示するためのドロップダウンボタンは表示されていない' do
        # コンテンツの中身が表示されていることを確認
        expect(page).to have_content blog_article.title
        expect(page).to have_content blog_article.content

        # 「編集」と「削除」ボタンを表示するためのドロップダウンメニューが表示されていない。また「編集」「削除」ボタンが表示されていない
        expect(page).not_to have_css '#blog-article-menu' # ドロップダウンメニューが表示されていない
        expect(page).not_to have_css '#blog-article-edit-link' # 「編集」ボタンが表示されていない
        expect(page).not_to have_css '#blog-article-delete-link' # 「削除」ボタンが表示されていない
      end
    end

    context '未ログインユーザー' do
      before do
        visit blog_article_path blog_article
      end

      it 'コンテンツの中身は正常に表示されているが、編集・削除ボタンを表示するためのドロップダウンボタンは表示されていない' do
        # コンテンツの中身が表示されていることを確認
        expect(page).to have_content blog_article.title
        expect(page).to have_content blog_article.content

        # 「編集」と「削除」ボタンを表示するためのドロップダウンメニューが表示されていない。また「編集」「削除」ボタンが表示されていない
        expect(page).not_to have_css '#blog-article-menu' # ドロップダウンメニューが表示されていない
        expect(page).not_to have_css '#blog-article-edit-link' # 「編集」ボタンが表示されていない
        expect(page).not_to have_css '#blog-article-delete-link' # 「削除」ボタンが表示されていない
      end
    end
  end
end
