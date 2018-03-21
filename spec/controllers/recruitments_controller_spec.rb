require 'rails_helper'

RSpec.describe RecruitmentsController, type: :controller do
  let(:user) {create(:user)}
  let(:other_user) {create(:user)}

  describe 'GET #index' do
    let(:title_1) { 'ナンパ仲間募集！今日新宿で！' }
    let(:title_2) { '本日の17時渋谷駅' }

    before do
      create(:recruitment, title: title_1)
      create(:recruitment, title: title_2)
      get :index
    end

    context 'レスポンス' do
      it 'ステータスコード200を返却 && :indexテンプレートがrenderされる' do
        aggregate_failures do
          expect(response).to have_http_status 200
          expect(response).to render_template :index
        end
      end
    end

    context 'インスタンス変数' do
      it 'コレクションの個数が正しい && それぞれのタイトルが正しい' do
        aggregate_failures do
          expect(assigns(:recruitments).count).to eq 2
          expect(assigns(:recruitments).pluck(:title)).to match_array [title_1, title_2]
        end
      end
    end
  end

  describe 'GET #show' do
    let(:recruitment) { create(:recruitment) }

    before { get :show, params: { id: recruitment.id } }

    context 'レスポンス' do
      it 'ステータスコード200を返却 && showテンプレートをrender' do
        aggregate_failures do
          expect(response).to have_http_status 200
          expect(response).to render_template :show
        end
      end
    end

    context 'インスタンス変数' do
      it '@recruitment & @messages & @new_message がそれぞれ正しい値を返す' do
        aggregate_failures do
          expect(assigns(:recruitment)).to eq recruitment
          expect(assigns(:messages).count).to eq 0
          expect(assigns(:new_message)).to be_a_new Message
        end
      end
    end
  end

  describe 'GET #new' do
    context "ログインユーザーの場合" do
      before do
        sign_in user
        get :new
      end

      context 'レスポンス' do
        it 'ステータスコード200を返却 && newテンプレートがをender' do
          aggregate_failures do
            expect(response).to have_http_status 200
            expect(response).to render_template :new
          end
        end
      end

      context 'インスタンス変数' do
        it '@recruitmentが新しいインスタンスである' do
          expect(assigns(:recruitment)).to be_a_new Recruitment
        end
      end
    end

    context "未ログインユーザーの場合" do
      before {get :new}

      context 'レスポンス' do
        it 'ステータスコード200を返却 && newテンプレートがをender' do
          aggregate_failures do
            expect(response).to have_http_status 302
            expect(response).to redirect_to new_user_session_path
          end
        end
      end
    end
  end

  describe 'POST #create' do
    context "ログインユーザー" do
      before {sign_in user}

      context '正常系' do
        let(:params) { { recruitment: attributes_for(:recruitment) } }

        context 'データ作成テスト' do
          it 'レコードが１つ増える && flash[:success]の中身が正しい && リダイレクト先が正しい' do
            aggregate_failures do
              expect { post :create, params: params }.to change(Recruitment, :count).by(1)
              expect(flash[:success]).to eq '募集記事の作成が完了しました。'
              expect(response).to redirect_to assigns(:recruitment)
            end
          end
        end
      end

      context '異常系' do
        context 'バリデーションに引っかかった場合' do
          let(:invalid_recruitment_attributes) do
            recruitment_attributes = attributes_for(:recruitment)
            recruitment_attributes[:title] = ''
            recruitment_attributes
          end
          let(:params) { { recruitment: invalid_recruitment_attributes } }

          context 'データ作成テスト' do
            it 'レコードが増えない && flash[:alert]の値が正しい && newテンプレートをrender' do
              aggregate_failures do
                expect { post :create, params: params }.not_to change(Recruitment, :count)
                expect(flash[:error]).to eq '募集記事の作成に失敗しました。'
                expect(response).to render_template :new
              end
            end
          end
        end
      end
    end

    context "未ログインユーザー" do
      before {post :create, params: params}

      let(:params) { { recruitment: attributes_for(:recruitment) } }

      context "レスポンス" do
        it 'ログインページにリダイレクトされる' do
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe 'GET #edit' do
    let(:params) {{ id: recruitment.id }}
    let(:recruitment) { create(:recruitment, user: user) }

    context "ログインユーザー && " do
      context "オーナー && " do
        let(:params) {{ id: recruitment.id }}

        before do
          sign_in user
          get :edit, params: params
        end

        context 'レスポンス' do
          it 'ログインページにリダイレクトされる' do
            aggregate_failures do
              expect(response).to have_http_status 200
              expect(response).to render_template :edit
            end
          end
        end

        context 'インスタンス変数' do
          it '期待するRecruitmentを取得できている' do
            expect(assigns(:recruitment)).to eq recruitment
          end
        end
      end

      context "オーナーでない && " do
        before do
          sign_in other_user
          get :edit, params: params
        end

        context 'レスポンス' do
          it 'ステータスコード302を返却 && ルートにリダイレクト && flashの値が正しい' do
            aggregate_failures do
              expect(response).to have_http_status 302
              expect(response).to redirect_to root_path
              expect(flash[:error]).to eq "不正な操作です。もう一度最初からやり直してください。"
            end
          end
        end
      end
    end

    context "未ログインユーザーの場合" do
      before {get :edit, params: params}

      context 'レスポンス' do
        it 'ステータスコード200を返却 && editテンプレートをrender' do
          aggregate_failures do
            expect(response).to have_http_status 302
            expect(response).to redirect_to new_user_session_path
          end
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:recruitment) { create(:recruitment, title: '修正前', user: user) }
    let(:recruitment_params) do
      recruitment_params = recruitment.attributes
      recruitment_params[:title] = '修正済み'
      recruitment_params
    end

    context "ログインユーザー && " do
      context "オーナー && " do
        before {sign_in user}

        context 'データ更新テスト' do
          context '正常系' do
            it 'フィールドの更新に成功する && flash[:success]の値が正しい && リダイレクト先が正しい' do
              aggregate_failures do
                expect(recruitment.title).to eq '修正前'
                patch :update, params: { id: recruitment.id, recruitment: recruitment_params }
                recruitment.reload
                expect(recruitment.title).to eq '修正済み'
                expect(flash[:success]).to eq '募集記事の更新が完了しました。'
                expect(response).to redirect_to assigns(:recruitment)
              end
            end
          end

          context '異常系' do
            let(:recruitment_params) do
              recruitment_params = recruitment.attributes
              recruitment_params['title'] = ''
              recruitment_params
            end

            it 'フィールドの更新に失敗する && flash[:alert]の値が正しい && editテンプレートをrender' do
              aggregate_failures do
                expect(recruitment.title).to eq '修正前'
                patch :update, params: { id: recruitment.id, recruitment: recruitment_params }
                recruitment.reload
                expect(recruitment.title).to eq '修正前'
                expect(flash[:error]).to eq '募集記事の更新に失敗しました。'
                expect(response).to render_template :edit
              end
            end
          end
        end
      end

      context "オーナーでない && " do
        before do
          sign_in other_user
          patch :update, params: { id: recruitment.id, recruitment: recruitment_params }
        end

        context 'レスポンス' do
          it 'ステータスコード302を返却 && ルートにリダイレクト && flashの値が正しい' do
            aggregate_failures do
              expect(response).to have_http_status 302
              expect(response).to redirect_to root_path
              expect(flash[:error]).to eq "不正な操作です。もう一度最初からやり直してください。"
            end
          end
        end
      end
    end

    context "未ログインユーザー && " do
      before do
        patch :update, params: { id: recruitment.id, recruitment: recruitment_params }
      end

      context 'レスポンス' do
        it 'ステータスコード302を返却 && ログインページにリダイレクト' do
          aggregate_failures do
            expect(response).to have_http_status 302
            expect(response).to redirect_to new_user_session_path
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:recruitment) { create(:recruitment, user: user) }
    let(:params) {{ id: recruitment.id }}

    context "ログインユーザー && " do
      context "オーナー &&" do
        before {sign_in user}

        it 'レコードが削除されている && flash[:success]の値が正しい && リダイレクト先が正しい' do
          aggregate_failures do
            expect { delete :destroy, params: params }.to change(Recruitment, :count).by(-1)
            expect { Recruitment.find(recruitment.id) }.to raise_exception ActiveRecord::RecordNotFound
            expect(flash[:success]).to eq '募集記事の削除が完了しました。'
            expect(response).to redirect_to root_path
          end
        end
      end

      context "オーナーでない &&" do
        before do
          sign_in other_user
          delete :destroy, params: params
        end

        it 'ルートにリダイレクトされる' do
          aggregate_failures do
            expect(response).to have_http_status 302
            expect(response).to redirect_to root_path
            expect(flash[:error]).to eq "不正な操作です。もう一度最初からやり直してください。"
          end
        end
      end
    end

    context "未ログインユーザー" do
      before {delete :destroy, params: params}

      it 'ログインページにリダイレクトされる' do
        aggregate_failures do
          expect(response).to have_http_status 302
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
