require 'rails_helper'

RSpec.describe 'EditBlogArticle', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:blog_article) { create(:blog_article, user: user, title: before_title, content: before_content) }

  let(:before_title) { 'ナンパと哲学について考察してみた' }
  let(:after_title) { 'ナンパと哲学について考察してみた' }
  let(:before_content) { '両者は完全に表裏一体の関係にある。' }
  let(:after_content) { '両者は完全に表裏一体の関係にある。と思ったがそんなことはなかった。' }

  context 'ログインユーザー' do
    context 'ブログ記事のオーナーである場合' do
      before { login_as user, scope: :user }

      it 'ブログ記事の更新に成功し、適切なflashメッセージが表示された状態でブログ記事詳細ページにリダイレクトされる' do
        # ブログ記事詳細ページの「編集」ボタンをクリック
        visit blog_article_path blog_article
        sleep 0.3

        # ブログ記事のコンテンツが表示されている
        expect(page).to have_content ''
        find('#blog-article-menu').click # ドロップダウンボタンをクリック
        find('#blog-article-edit-link').click # 「編集」ボタンをクリック
        sleep 0.3

        # フォームを埋めて更新ボタンをクリック
        fill_in 'blog_article[title]', with: after_title
        fill_in 'blog_article[content]', with: after_content
        click_button '更新'
        sleep 0.3

        # 適切なフラッシュメッセージが表示された状態でブログ記事詳細ページに遷移する
        expect(page).to have_content 'ブログの更新が完了しました。'
        expect(current_path).to eq blog_article_path blog_article

        # 更新された状態のコンテンツが表示されている
        expect(page).to have_content after_title
        expect(page).to have_content after_content
      end
    end
    context 'ブログ記事のオーナーでない場合' do
      before { login_as other_user, scope: :user }

      it 'オーナー以外のユーザーがブログ記事の編集ページに遷移しようとした場合は、適切なフラッシュメッセージとともにブログ記事一覧ページにリダイレクトさせる' do
        # 未ログインユーザーが他人のブログ記事の編集ページを開こうとした
        visit edit_blog_article_path(blog_article)
        sleep 0.3

        # 適切なフラッシュメッセージが表示された状態でブログ記事一覧ページにリダイレクトさせる
        expect(current_path).to eq blog_articles_path
        expect(page).to have_content '不正な操作です。もう一度最初からやり直してください。'
      end
    end
  end

  context '未ログインユーザー' do
    it 'ログインページにリダイレクトされること' do
      # 未ログインユーザーが他人のブログ記事の編集ページを開こうとした
      visit edit_blog_article_path(blog_article)
      sleep 0.3

      # 適切なflashメッセージが表示された状態でログインページにリダイレクトされること
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
      expect(current_path).to eq new_user_session_path
    end
  end
end
