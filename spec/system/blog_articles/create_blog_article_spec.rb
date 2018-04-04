require 'rails_helper'

RSpec.describe 'CreateBlogArticle', type: :system do
  context 'ログインユーザー' do
    let(:user) { create(:user) }
    before { login_as user, scope: :user }

    context '正常系' do
      let(:title) { 'はじめてナンパをしました。撃沈です。' }
      let(:content) { '精神的に参っています。挫折しそうです。' }

      it '正常に投稿が完了し、適切なflashメッセージが表示された状態でブログ記事詳細ページにリダイレクトすること' do
        # ブログ記事一覧ページに飛ぶ
        visit blog_articles_path
        find('#bottom-fixed-button').click # 右下のブログ記事作成ボタンをクリック
        sleep 0.3

        # フォームを埋めて記事を作成
        fill_in 'blog_article[title]', with: title
        fill_in 'blog_article[content]', with: content
        click_button '作成'
        sleep 0.3

        # ブログ記事詳細ページに遷移し、適切なコンテンツが表示されている
        expect(page).to have_content 'ブログの投稿が完了しました。'
        expect(current_path).to eq blog_article_path(BlogArticle.first)
        expect(page).to have_content title
        expect(page).to have_content content
      end
    end

    context '異常系' do
      it 'クライアントバリデーションに引っかかり、ブログ記事の投稿ができないこと' do
        visit new_blog_article_path
        sleep 0.3

        # クライアントバリデーションに引っかかるように値を入力し作成ボタンをクリックする
        # 何も入力がなかった場合
        click_button '作成'
        expect(page).to have_content '[タイトル] 入力必須です。'
        expect(page).to have_content '[本文] 入力必須です。'

        # 文字数制限に引っかかった場合
        fill_in 'blog_article[title]', with: 'あ' * (BlogArticle::MAXIMUM_TITLE_LENGTH + 1)
        fill_in 'blog_article[content]', with: 'あ' * (BlogArticle::MAXIMUM_CONTENT_LENGTH + 1)
        click_button '作成'
        expect(page).to have_content '[タイトル] 128文字以下で入力してください。'
        expect(page).to have_content '[本文] 4096文字以下で入力してください。'
      end
    end
  end

  context '未ログインユーザー' do
    it 'ログインページにリダイレクトされること' do
      visit new_blog_article_path
      sleep 0.3

      # 適切なflashメッセージが表示された状態でログインページにリダイレクトされること
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
      expect(current_path).to eq new_user_session_path
    end
  end
end
