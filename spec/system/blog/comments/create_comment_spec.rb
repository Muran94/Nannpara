require "rails_helper"

RSpec.describe "CreateComment", type: :system do
  let(:user) {create(:user)}
  let(:blog_article) {create(:blog_article)}

  context "ログインユーザー" do
    before do
      login_as user, scope: :user
      visit blog_article_path blog_article
    end

    context "正常系" do
      let(:blog_comment_content) {"コメントの投稿が完了しました。"}

      it "コメントの投稿に成功し、適切なフラッシュメッセージが表示された状態でブログ記事詳細画面にリダイレクトされること" do
        # ブログ記事のコンテンツが表示されている
        expect(page).to have_content blog_article.title
        expect(page).to have_content blog_article.content

        # フォームを埋めて「コメント送信」ボタンをクリック
        fill_in "blog_comment[content]", with: "楽しく読ませていただきました！"
        click_button "コメント送信"
        sleep 0.1

        # フラッシュメッセージが表示されており、ブログ記事詳細ページにリダイレクトされていること
        expect(page).to have_content blog_comment_content
        expect(current_path).to eq blog_article_path blog_article

        # コメントが追加されていること
        expect(page).to have_content blog_comment_content
      end
    end
    context "異常系" do
      it "クライアントバリデーションにひっかかり、コメントの投稿が完了しないこと" do
        # ブログ記事のコンテンツが表示されている
        expect(page).to have_content blog_article.title
        expect(page).to have_content blog_article.content

        # フォームを埋めて「コメント送信」ボタンをクリック
        # まずは空のまま「コメント送信」ボタンをクリック
        click_button "コメント送信"
        sleep 0.1
        expect(page).to have_content "[本文] 入力必須です。"

        fill_in "blog_comment[content]", with: "a" * (Blog::Comment::MAXIMUM_CONTENT_LENGTH + 1)
        click_button "コメント送信"
        sleep 0.1
        expect(page).to have_content "[本文] 512文字以下で入力してください。"
      end
    end
  end

  context "未ログインユーザー" do
    before {visit blog_article_path blog_article}

    it "「コメントをするにはログインが必要です。」の文言とともにログインページへのリンクが設置されていること" do
      # ブログ記事のコンテンツが表示されている
      expect(page).to have_content blog_article.title
      expect(page).to have_content blog_article.content

      # 「コメントをするにはログインが必要です。」の文言が表示されていること
      expect(page).to have_content "コメントをするにはログインが必要です。"
    end
  end
end
