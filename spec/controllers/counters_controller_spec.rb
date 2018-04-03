require 'rails_helper'

RSpec.describe CountersController, type: :controller do
  shared_examples 'newアクションの動作検証' do
    context 'レスポンス' do
      it 'レスポンスコード200を返却 && :newテンプレートをrenderする' do
        aggregate_failures do
          expect(response).to have_http_status 200
          expect(response).to render_template :new
        end
      end
    end

    context 'インスタンス変数' do
      it '@speak_countと@tel_countと@sex_countが定義されている' do
        aggregate_failures do
          expect(assigns(:speak_count)).to eq 0
          expect(assigns(:tel_count)).to eq 0
          expect(assigns(:sex_count)).to eq 0
        end
      end
    end
  end

  context 'ログイン済み' do
    let(:user) { create(:user) }
    before { sign_in user }

    describe 'GET #new' do
      context 'params["period"]がday' do
        before { get :new, params: { period: 'day' } }

        it_behaves_like 'newアクションの動作検証'
      end

      context 'params["period"]がweek' do
        before { get :new, params: { period: 'week' } }

        it_behaves_like 'newアクションの動作検証'
      end

      context 'params["period"]がmonth' do
        before { get :new, params: { period: 'month' } }

        it_behaves_like 'newアクションの動作検証'
      end

      context 'params["period"]がない場合' do
        before { get :new }

        it_behaves_like 'newアクションの動作検証'
      end
    end

    describe 'POST #create' do
      context '正常系' do
        let(:params) do
          {
            counter_type: '即',
            period: 'day'
          }
        end
        it 'データ生成テスト' do
          aggregate_failures do
            expect { post :create, params: params }.to change(Counter, :count).by(1)
            expect(Counter.where(counter_type: '即').count).to eq 1
            expect(response).to redirect_to new_counter_path(period: 'day')
          end
        end
      end

      context '異常系' do
        let(:params) do
          {
            counter_type: 'チョコバー',
            period: 'week'
          }
        end
        it '異常データを渡した際にバリデーションに引っかかること' do
          aggregate_failures do
            expect { post :create, params: params }.not_to change(Counter, :count)
            expect(Counter.count).to eq 0
            expect(flash[:error]).to eq '不正な操作です。もう一度やり直してください。'
            expect(response).to redirect_to new_counter_path(period: 'week')
          end
        end
      end
    end
  end

  context '未ログイン状態' do
    describe 'GET #new' do
      before { get :new }

      it 'ログインページにリダイレクトされる' do
        aggregate_failures do
          expect(response).to have_http_status 302
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    describe 'POST #create' do
      let(:params) do
        {
          counter_type: '即',
          period: 'month'
        }
      end
      before { post :create, params: params }

      it 'ログインページにリダイレクトされる' do
        aggregate_failures do
          expect(response).to have_http_status 302
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
