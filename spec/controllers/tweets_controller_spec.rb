require 'rails_helper'

RSpec.describe TweetsController, type: :controller do
  describe 'GET #index' do
    let(:first_tweet_content) { 'first tweet' }
    let(:second_tweet_content) { 'second tweet' }
    let(:third_tweet_content) { 'third tweet' }

    before do
      create(:tweet, content: first_tweet_content, created_at: 1.day.ago)
      create(:tweet, content: second_tweet_content, created_at: 2.day.ago)
      create(:tweet, content: third_tweet_content, created_at: 3.day.ago)
      get :index
    end

    context 'レスポンス' do
      it 'ステータスコード200を返し、indexテンプレードをrenderすること' do
        aggregate_failures do
          expect(response).to have_http_status 200
          expect(response).to render_template :index
        end
      end
    end

    context 'インスタンス変数' do
      it 'インスタンス変数の数と、順番が正しいこと' do
        aggregate_failures do
          expect(assigns(:tweets).count).to eq 3
          expect(assigns(:tweets).pluck(:content)).to match_array [first_tweet_content, second_tweet_content, third_tweet_content]
        end
      end
    end
  end

  describe 'GET #show' do
    let(:tweet) { create(:tweet) }
    let(:params) { { id: tweet.id } }

    before { get :show, params: params }

    context 'レスポンス' do
      it 'ステータスコード200を返し、showテンプレートがrenderされること' do
        aggregate_failures do
          expect(response).to have_http_status 200
          expect(response).to render_template :show
        end
      end
    end

    context 'インスタンス変数' do
      it '正しいインスタンス変数が定義されること' do
        expect(assigns(:tweet)).to eq Tweet.find(tweet.id)
      end
    end
  end

  describe 'GET #new' do
    context 'ログインユーザー' do
      let(:user) { create(:user) }

      before do
        sign_in user
        get :new
      end

      context 'レスポンス' do
        it 'ステータスコード200が返ってくる && newテンプレートをrenderすること' do
          aggregate_failures do
            expect(response).to have_http_status 200
            expect(response).to render_template :new
          end
        end
      end

      context 'インスタンス変数' do
        it '新しいTweetがインスタンス化されること' do
          expect(assigns(:tweet)).to be_a_new Tweet
        end
      end
    end

    context '未ログインユーザー' do
      before { get :new }

      context 'レスポンス' do
        it 'ステータスコード302 && ログインページにリダイレクトされる' do
          aggregate_failures do
            expect(response).to have_http_status 302
            expect(response).to redirect_to new_user_session_path
          end
        end
      end
    end
  end

  describe 'GET #create' do
    context 'ログインユーザー' do
      let(:user) { create(:user) }
      before { sign_in user }

      context '正常系' do
        let(:params) do
          {
            tweet: {
              content: content
            }
          }
        end
        let(:content) { '今日中に50人声かけする。' }

        context 'データ作成とレスポンス' do
          it 'データが１つ増え、flash[:success]に適切な値が代入され、tweetのshowページにリダイレクトされること' do
            aggregate_failures do
              expect { post :create, params: params }.to change(Tweet, :count).by(1)
              expect(Tweet.first.content).to eq content
              expect(flash[:success]).to eq 'つぶやきが完了しました。'
              expect(response).to have_http_status 302
              expect(response).to redirect_to tweets_path
            end
          end
        end
      end

      context '異常系' do
        let(:params) do
          {
            tweet: {
              content: 'あ' * (Tweet::MAXIMUM_CONTENT_LENGTH + 1)
            }
          }
        end
        let(:content) { '今日中に50人声かけする。' }

        context 'バリデーションテストとレスポンス' do
          it 'データが増えず、flash[:error]に適切な値が代入され、:newテンプレートがrenderされること' do
            aggregate_failures do
              expect { post :create, params: params }.not_to change(Tweet, :count)
              expect(Tweet.count).to eq 0
              expect(flash[:error]).to eq 'つぶやけませんでした。'
              expect(response).to render_template :new
            end
          end
        end
      end
    end

    context '未ログインユーザー' do
      let(:params) do
        {
          tweet: {
            content: '今日中に50人声かけする。'
          }
        }
      end

      context 'レスポンス' do
        it 'ステータスコード302 && ログインページにリダイレクトされる' do
          aggregate_failures do
            post :create, params: params
            expect(response).to have_http_status 302
            expect(response).to redirect_to new_user_session_path
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'ログインユーザー' do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      before { sign_in user }

      context 'Tweet主とログインユーザーが一致している場合' do
        context 'つぶやきの削除とレスポンス' do
          let!(:tweet) { create(:tweet, user: user) }
          let(:params) { { id: tweet.id } }

          it 'Tweetが削除され、flash[:success]に適切な値が代入され、つぶやき一覧ページにリダイレクトされる' do
            aggregate_failures do
              expect { delete :destroy, params: params }.to change(Tweet, :count).by(-1)
              expect(flash[:success]).to eq 'つぶやきの削除が完了しました。'
              expect(response).to redirect_to tweets_path
            end
          end
        end
      end

      context 'Tweet主とログインユーザーが一致していない場合' do
        context 'つぶやきの削除とレスポンス' do
          let!(:tweet) { create(:tweet, user: other_user) }
          let(:params) { { id: tweet.id } }

          it 'Tweetが削除され、flash[:success]に適切な値が代入され、つぶやき一覧ページにリダイレクトされる' do
            aggregate_failures do
              expect { delete :destroy, params: params }.not_to change(Tweet, :count)
              expect(flash[:error]).to eq '不正な操作です。もう一度最初からやり直してください。'
              expect(response).to redirect_to tweets_path
            end
          end
        end
      end
    end
    context '未ログインユーザー' do
      let(:tweet) { create(:tweet) }
      let(:params) { { id: tweet.id } }

      context 'レスポンス' do
        it 'ステータスコード302 && ログインページにリダイレクトされる' do
          aggregate_failures do
            delete :destroy, params: params
            expect(response).to have_http_status 302
            expect(response).to redirect_to new_user_session_path
          end
        end
      end
    end
  end
end
