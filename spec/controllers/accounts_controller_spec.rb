require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  before { sign_in(user) }

  describe %(GET #profile) do
    before { get :profile, params: params }

    context '自分のマイページを確認' do
      let(:params) { { id: user.id } }

      context 'レスポンス' do
        it 'ステータスコード200を返却 && showテンプレートをrender' do
          aggregate_failures do
            expect(response).to have_http_status 200
            expect(response).to render_template :profile
          end
        end
      end

      context 'インスタンス変数' do
        it '@userと@recruitmentsの値がそれぞれ正しいこと' do
          expect(assigns(:user)).to eq user
        end
      end
    end

    context '他人のマイページを確認' do
      let(:params) { { id: other_user.id } }

      context 'レスポンス' do
        it 'ステータスコード200を返却 && showテンプレートをrender' do
          aggregate_failures do
            expect(response).to have_http_status 200
            expect(response).to render_template :profile
          end
        end
      end

      context 'インスタンス変数' do
        it '@userの値が正しいこと' do
          expect(assigns(:user)).to eq other_user
        end
      end
    end
  end

  describe %(GET #profile) do
    before { get :recruitments, params: params }

    context '自分のマイページを確認' do
      let(:params) { { id: user.id } }

      context 'レスポンス' do
        it 'ステータスコード200を返却 && showテンプレートをrender' do
          aggregate_failures do
            expect(response).to have_http_status 200
            expect(response).to render_template :recruitments
          end
        end
      end

      context 'インスタンス変数' do
        let(:user) { create(:user, :with_recruitments) }

        it '@userと@recruitmentsの値がそれぞれ正しいこと' do
          expect(assigns(:recruitments)).to match_array user.recruitments
        end
      end
    end

    context '他人のマイページを確認' do
      let(:params) { { id: other_user.id } }

      context 'レスポンス' do
        it 'ステータスコード200を返却 && showテンプレートをrender' do
          aggregate_failures do
            expect(response).to have_http_status 200
            expect(response).to render_template :recruitments
          end
        end
      end

      context 'インスタンス変数' do
        let(:other_user) { create(:user, :with_recruitments) }

        it '@userの値が正しいこと' do
          expect(assigns(:recruitments)).to match_array other_user.recruitments
        end
      end
    end
  end

  describe %(GET #edit) do
    before { get :edit }
    context 'レスポンス' do
      it 'ステータスコード200を返却 && showテンプレートをrender' do
        aggregate_failures do
          expect(response).to have_http_status 200
          expect(response).to render_template :edit
        end
      end
    end

    context 'インスタンス変数' do
      it '@userの値が正しいこと' do
        expect(assigns(:current_user)).to eq user
      end
    end
  end

  describe %(PATCH/PUT #update) do
    let(:user) do
      create(
        :user,
        introduction: 'あああ',
        age: User::MINIMUM_AGE,
        prefecture_code: 13,
        experience: '1年'
      )
    end

    before { patch :update, params: params }

    context %(自分のプロフィールに対して編集リクエストを送信) do
      let(:new_introduction) { 'いいい' }
      let(:new_age) { 20 }
      let(:new_prefecture_code) { 10 }
      let(:new_experience) { '3年' }

      let(:params) do
        {
          user: {
            introduction: new_introduction,
            age: new_age,
            prefecture_code: new_prefecture_code,
            experience: new_experience
          }
        }
      end

      it 'プロフィールの更新が完了する && flash[:sucess]の値が正しい && マイページにリダイレクト' do
        aggregate_failures do
          expect(user.age).to eq User::MINIMUM_AGE # 更新前の値を検証
          patch :update, params: params
          user.reload
          expect(user.introduction).to eq new_introduction
          expect(user.age).to eq new_age
          expect(user.prefecture_code).to eq new_prefecture_code
          expect(user.experience).to eq new_experience
          expect(flash[:success]).to eq 'プロフィール更新が完了しました。'
          expect(response).to redirect_to profile_account_path(user)
        end
      end
    end
  end

  describe %(GET #edit_password) do
    before { get :edit_password }

    context %(自分のアカウントのパスワード変更画面を開こうとする) do
      context %(レスポンス) do
        it %(ステータスコード200を返却 && edit_passwordテンプレートをrender) do
          aggregate_failures do
            expect(response).to have_http_status 200
            expect(response).to render_template :edit_password
          end
        end
      end

      context %(インスタンス変数) do
        it %(@userの値が正しいこと) do
          expect(assigns(:current_user)).to eq user
        end
      end
    end
  end

  describe %(PATCH #update_password) do
    let(:before_password) { 'before_password' }
    let(:after_password) { 'after_password' }
    let!(:user) { create(:user, password: before_password, password_confirmation: before_password) }
    before { patch :update_password, params: params }

    context %(正常系) do
      let(:params) do
        {
          user: {
            current_password: before_password,
            password: after_password,
            password_confirmation: after_password
          }
        }
      end
      context %(リクエスト) do
        it %(ステータスコード302を返却 && マイページにリダイレクト) do
          aggregate_failures do
            expect(response).to have_http_status 302
            expect(response).to redirect_to profile_account_path(user)
          end
        end
      end

      context %(異常系) do
        let(:params) do
          {
            user: {
              current_password: before_password,
              password: after_password,
              password_confirmation: 'asajdfpasjdf' # 意図的に違うパスワードを入力
            }
          }
        end
        context %(リクエスト) do
          it %(:edit_passwordをrender) do
            expect(response).to render_template :edit_password
          end
        end
      end
    end
  end
end
