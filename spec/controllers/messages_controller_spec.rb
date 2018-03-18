require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  describe 'POST #create' do
    let(:recruitment) { create(:recruitment) }

    context 'データ作成テスト' do
      context '正常系' do
        let(:params) do
          {
            recruitment_id: recruitment.id,
            message: {
              message: '僕も参加していいですか！？'
            }
          }
        end
        context 'ログインユーザーによるメッセージの場合' do
          let(:user) { create(:user) }
          before { sign_in(user) }

          it 'レコードが一つ増える && 正しいユーザーが登録されている && flash[:success]の値が正しい && リダイレクト先が正しい' do
            aggregate_failures do
              expect { post :create, params: params }.to change(Message, :count).by(1)
              expect(assigns(:message).user_id).to eq user.id
              expect(flash[:success]).to eq 'メッセージの送信に成功しました。'
              expect(response).to redirect_to recruitment
            end
          end
        end
        context '未ログインユーザーによるメッセージの場合' do
          it 'レコードが一つ増える && user_idが登録されていない && flash[:success]の値が正しい && リダイレクト先が正しい' do
            aggregate_failures do
              expect { post :create, params: params }.to change(Message, :count).by(1)
              expect(assigns(:message).user_id).to eq nil
              expect(flash[:success]).to eq 'メッセージの送信に成功しました。'
              expect(response).to redirect_to recruitment
            end
          end
        end
      end
      context '異常系' do
        let(:params) do
          {
            recruitment_id: recruitment.id,
            message: {
              message: ''
            }
          }
        end

        it 'レコードが増えない && flash[:alert]の値が正しい && recruitment/newがrenderされること' do
          aggregate_failures do
            expect { post :create, params: params }.not_to change(Message, :count)
            expect(flash[:error]).to eq 'メッセージの送信に失敗しました。'
            expect(response).to render_template 'recruitments/new'
          end
        end
      end
    end
  end
end
