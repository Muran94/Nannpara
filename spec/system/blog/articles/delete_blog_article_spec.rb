require 'rails_helper'

RSpec.describe 'DeleteBlogArticle', type: :system do
  let(:user) { create(:user) }
  let(:blog_article) { create(:blog_article, user: user, title: title) }
  let(:title) { '削除予定のブログ記事です。' }

  before { login_as user, scope: :user }

  it 'ブログ記事の削除に成功し、適切なフラッシュメッセージとともにブログ記事一覧ページにリダイレクトされる' do
    # ブログ記事の詳細ページに遷移
    visit blog_article_path blog_article
    sleep 0.3

    # 削除予定のブログ記事のタイトルが表示されていること
    expect(page).to have_content title

    # 削除ボタンをクリック
    find('#blog-article-menu').click # ドロップダウンボタンをクリック
    find('#blog-article-delete-link').click # 「削除」ボタンをクリック
    page.driver.browser.switch_to.alert.accept # confirmダイアログのOKボタンをクリック
    sleep 0.3

    # 適切なフラッシュメッセージが表示された状態でブログ記事一覧ページにリダイレクトされ、削除したブログ記事のタイトルが表示されていないこと
    expect(page).to have_content 'ブログ記事の削除が完了しました。'
    expect(current_path).to eq blog_articles_path
    expect(page).not_to have_content title
  end
end
