require 'rails_helper'

RSpec.describe TweetNicesController, type: :controller do
  subject(:json_response) { JSON.parse(response.body) }

  describe "POST #create" do
    let(:user) {create(:user)}
    let(:tweet) {create(:tweet)}
    let(:params) do
      {
        params: {
          tweet_id: tweet.id
        }
      }
    end

    context "ログインユーザー" do
      before {sign_in user}

      context "正常系" do
        it "TweetNiceの作成に成功し、適切なjsonレスポンスを返す" do
          aggregate_failures do
            expect {post :create, params}.to change(TweetNice, :count).by(1)
            expect(json_response['status']).to eq "created"
          end
        end
      end

      context "異常系" do
        context "バリデーションに引っかかった場合 - 同じユーザーかつ同じTweetに対する「いいね」が存在する場合" do
          before {create(:tweet_nice, user: user, tweet: tweet)}

          it "TweetNiceの作成に失敗し、適切なjsonレスポンスを返す" do
            aggregate_failures do
              expect {post :create, params}.not_to change(TweetNice, :count)
              expect(json_response['status']).to eq "tweet_nice_duplicated"
            end
          end
        end

        context "何かしらの理由でTweetNiceの作成に失敗した場合" do
          before {allow_any_instance_of(TweetNice).to receive(:save).and_return(false)}

          it "適切なjsonレスポンスを返す" do
            aggregate_failures do
              expect {post :create, params}.not_to change(TweetNice, :count)
              expect(json_response['status']).to eq "unprocessable_entity"
            end
          end
        end
      end
    end
    context "未ログインユーザー" do
      it "ログインページにリダイレクトされる" do
        post :create, params
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE #destroy" do
    let(:user) {create(:user)}
    let(:other_user) {create(:user)}
    let(:tweet) {create(:tweet)}
    let(:params) do
      {
        params: {
          tweet_id: tweet.id
        }
      }
    end

    context "ログインユーザー" do
      before {sign_in user}

      context "正常系" do
        before do
          sign_in user
          create(:tweet_nice, user: user, tweet: tweet)
        end

        it "TweetNiceの削除に成功し、適切なjsonレスポンスを返す" do
          aggregate_failures do
            expect {delete :destroy, params}.to change(TweetNice, :count).by(-1)
            expect(json_response['status']).to eq "deleted"
          end
        end
      end

      context "異常系" do
        context "既に「いいね」が削除されている場合" do
          before {sign_in user}

          it "TweetNiceの削除に失敗し、適切なjsonレスポンスを返す" do
            aggregate_failures do
              expect {delete :destroy, params}.not_to change(TweetNice, :count)
              expect(json_response['status']).to eq "already_deleted"
            end
          end
        end
      end
    end

    context "未ログインユーザー" do
      it "ログインページにリダイレクトされる" do
        aggregate_failures do
          delete :destroy, params
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
