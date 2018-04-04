require 'rails_helper'

RSpec.describe BlogCommentsController, type: :controller do

  describe "POST #create" do
    let(:blog_article) {create(:blog_article)}
    let(:blog_comment_attributes) {attributes_for(:blog_comment)}
    let(:params) do
      {
        params: {
          blog_article_id: blog_article.id,
          blog_comment: blog_comment_attributes
        }
      }
    end
    context "ログイン済み" do
      let(:user) {create(:user)}
      before {sign_in user}

      context "正常系" do
        it "コメントの投稿に成功し、適切なflash[:success]メッセージとともにブログ記事詳細ページにリダイレクトされること" do
          aggregate_failures do
            expect {post :create, params}.to change(BlogComment, :count).by(1)
            expect(BlogComment.first.user_id).not_to be_nil
            expect(flash[:success]).to eq "コメントの投稿が完了しました。"
            expect(response).to redirect_to blog_article
          end
        end
      end

      context "異常系" do
        let(:blog_comment_attributes) {attributes_for(:blog_comment, :invalid_content)}

        it "コメントの投稿に失敗し、適切なflash[:error]メッセージとともにブログ記事詳細ページにリダイレクトされること" do
          aggregate_failures do
            expect {post :create, params}.not_to change(BlogComment, :count)
            expect(flash[:error]).to eq "コメントの投稿に失敗しました。"
            expect(response).to redirect_to blog_article
          end
        end
      end
    end
    context "未ログイン" do
      it 'ログインページにリダイレクトされる' do
        aggregate_failures do
          post :create, params
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe "DELETE #destroy" do
    let(:comment_owner) {create(:user)}
    let(:blog_article_owner) {create(:user)}
    let(:other_user) {create(:user)}
    let(:blog_article) {create(:blog_article, user: blog_article_owner)}
    let!(:blog_comment) {create(:blog_comment, blog_article: blog_article, user: comment_owner)}
    let(:params) do
      {
        params: {
          blog_article_id: blog_article.id,
          id: blog_comment.id
        }
      }
    end

    context "ログイン済み" do
      context "コメントのオーナーである" do
        before {sign_in comment_owner}

        it "コメントの削除に成功し、適切なフラッシュメッセージとともにブログ記事詳細ページにリダイレクトされる。" do
          aggregate_failures do
            expect {delete :destroy, params}.to change(BlogComment, :count).by(-1)
            expect(flash[:success]).to eq "コメントを削除しました。"
            expect(response).to redirect_to blog_article
          end
        end
      end

      context "コメントのオーナーではないが、ブログ記事のオーナーである" do
        before {sign_in blog_article_owner}

        it "コメントの削除に成功し、適切なフラッシュメッセージとともにブログ記事詳細ページにリダイレクトされる。" do
          aggregate_failures do
            expect {delete :destroy, params}.to change(BlogComment, :count).by(-1)
            expect(flash[:success]).to eq "コメントを削除しました。"
            expect(response).to redirect_to blog_article
          end
        end
      end

      context "コメントオーナーでも、ブログ記事のオーナーでもない" do
        before {sign_in other_user}

        it "不正な操作なので、適切なメッセージとともにブログ記事詳細ページにリダイレクトさせる" do
          aggregate_failures do
            expect {delete :destroy, params}.not_to change(BlogComment, :count)
            expect(flash[:error]).to eq "不正な操作です。もう一度最初からやり直してください。"
            expect(response).to redirect_to blog_article
          end
        end
      end
    end
    context "未ログイン" do
      it 'ログインページにリダイレクトされる' do
        aggregate_failures do
          post :create, params
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
