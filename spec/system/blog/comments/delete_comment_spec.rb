require "rails_helper"

RSpec.describe "DeleteComment", type: :system do
  let(:comment_owner) {create(:user)}
  let(:blog_article_owner) {create(:user)}
  let(:other_user) {create(:user)}
  let(:blog_article) {create(:blog_article, user: blog_article_owner)}
  let!(:comments) do
    [
      create(:blog_comment, content: "ブログ記事オーナーのコメント", blog_article: blog_article, user: blog_article_owner, created_at: 1.day.ago),
      create(:blog_comment, content: "コメントオーナーのコメント", blog_article: blog_article, user: comment_owner, created_at: 2.day.ago)
    ]
  end

  context "ログイン済み" do
    context "コメントのオーナーである場合" do
      it "自分のコメントに「削除」ボタンが表示されているおり、削除できること" do
        login_as comment_owner, scope: :user
        visit blog_article_path blog_article

        # ブログ記事のコンテンツが表示されていること
        expect(page).to have_content blog_article.title
        expect(page).to have_content blog_article.content

        # コメントが２件あること
        expect(page).to have_content comments[0].content
        expect(page).to have_content comments[1].content

        # 自分のコメントに削除ボタンが表示されていることを確認 ※ 厳密なテストではないがテスト実装がめんどうなので以下のように検証している。
        expect(all(".delete-blog-comment-button").count).to eq 1

        # 残りのコメントも削除
        find(".delete-blog-comment-button").click # 削除
        page.driver.browser.switch_to.alert.accept
        sleep 0.1

        # フラッシュメッセージが表示されていることを確認
        expect(page).to have_content "コメントを削除しました。"
        expect(current_path).to eq blog_article_path blog_article

        # コメントが表示されていないことを確認
        expect(all(".delete-blog-comment-button").count).to eq 0
      end
    end

    context "ブログ記事のオーナーである場合" do
      it "全てのコメントに「削除」ボタンが表示されていること、全て削除できること" do
        login_as blog_article_owner, scope: :user
        visit blog_article_path blog_article

        # ブログ記事のコンテンツが表示されていること
        expect(page).to have_content blog_article.title
        expect(page).to have_content blog_article.content

        # コメントが２件あること
        expect(page).to have_content comments[0].content
        expect(page).to have_content comments[1].content

        # 自分のコメントに削除ボタンが表示されていることを確認 ※ 厳密なテストではないがテスト実装がめんどうなので以下のように検証している。
        expect(all(".delete-blog-comment-button").count).to eq 2

        # ２つのコメントを削除
        all(".delete-blog-comment-button")[0].click # 削除
        page.driver.browser.switch_to.alert.accept
        sleep 0.1

        # フラッシュメッセージが表示されていることを確認
        expect(page).to have_content "コメントを削除しました。"
        expect(current_path).to eq blog_article_path blog_article

        # 残りのコメントも削除
        find(".delete-blog-comment-button").click # 削除
        page.driver.browser.switch_to.alert.accept
        sleep 0.1

        # フラッシュメッセージが表示されていることを確認
        expect(page).to have_content "コメントを削除しました。"
        expect(current_path).to eq blog_article_path blog_article

        # コメントが表示されていないことを確認
        expect(page).to have_content "まだコメントがありません。"
      end
    end

    context "コメントオーナーでもブログ記事オーナーでもない場合" do
      it "どのコメントにも「削除」ボタンが表示されていないこと" do
        login_as other_user, scope: :user
        visit blog_article_path blog_article

        # ブログ記事のコンテンツが表示されていること
        expect(page).to have_content blog_article.title
        expect(page).to have_content blog_article.content

        # コメントが２件あること
        expect(page).to have_content comments[0].content
        expect(page).to have_content comments[1].content

        # 自分のコメントに削除ボタンが表示されていることを確認 ※ 厳密なテストではないがテスト実装がめんどうなので以下のように検証している。
        expect(all(".delete-blog-comment-button").count).to eq 0
      end
    end
  end

  context "未ログイン" do
    it "どのコメントにも「削除」ボタンが表示されていないこと" do
      visit blog_article_path blog_article

      # ブログ記事のコンテンツが表示されていること
      expect(page).to have_content blog_article.title
      expect(page).to have_content blog_article.content

      # コメントが２件あること
      expect(page).to have_content comments[0].content
      expect(page).to have_content comments[1].content

      # 自分のコメントに削除ボタンが表示されていることを確認 ※ 厳密なテストではないがテスト実装がめんどうなので以下のように検証している。
      expect(all(".delete-blog-comment-button").count).to eq 0
    end
  end
end
