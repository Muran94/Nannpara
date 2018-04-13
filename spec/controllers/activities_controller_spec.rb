require 'rails_helper'

RSpec.describe ActivitiesController, type: :controller do
  let(:user) {create(:user)}

  describe "GET #show" do
    context "ログインユーザー" do
      before {sign_in user}

      context "paramsあり" do
        before do
          create(:activity, activity_type: create(:activity_type, :talk), created_at: 1.minute.ago, user: user)
          create(:activity, activity_type: create(:activity_type, :talk), created_at: 2.days.ago, user: user)
          create(:activity, activity_type: create(:activity_type, :talk), created_at: 8.days.ago, user: user)
          create(:activity, activity_type: create(:activity_type, :talk), created_at: 32.days.ago, user: user)
          get :show, params
        end
        context "params['period'] = '本日'" do
          let(:params) {{params: {period: "本日"}}}

          context "レスポンス" do
            it "ステータスコード200を返却し、:showテンプレートをrenderされる。また、自動でparams['period']に'本日'がセットされる" do
              aggregate_failures do
                expect(response).to have_http_status 200
                expect(response).to render_template :show
                expect(controller.params["period"]).to eq "本日"
              end
            end
          end

          context "インスタンス変数" do
            it "正しいインスタンス変数がセットされていること" do
              aggregate_failures do
                expect(assigns(:talk_count)).to eq 1
                expect(assigns(:get_phone_number_count)).to eq 0
                expect(assigns(:date_count)).to eq 0
                expect(assigns(:instant_sex_count)).to eq 0
                expect(assigns(:sex_on_first_date_count)).to eq 0
                expect(assigns(:sex_on_second_date_count)).to eq 0
              end
            end
          end
        end

        context "params['period'] = '週間'" do
          let(:params) {{params: {period: "週間"}}}

          context "レスポンス" do
            it "ステータスコード200を返却し、:showテンプレートをrenderされる。また、自動でparams['period']に'本日'がセットされる" do
              aggregate_failures do
                expect(response).to have_http_status 200
                expect(response).to render_template :show
                expect(controller.params["period"]).to eq "週間"
              end
            end
          end

          context "インスタンス変数" do
            it "正しいインスタンス変数がセットされていること" do
              aggregate_failures do
                expect(assigns(:talk_count)).to eq 2
                expect(assigns(:get_phone_number_count)).to eq 0
                expect(assigns(:date_count)).to eq 0
                expect(assigns(:instant_sex_count)).to eq 0
                expect(assigns(:sex_on_first_date_count)).to eq 0
                expect(assigns(:sex_on_second_date_count)).to eq 0
              end
            end
          end
        end

        context "params['period'] = '月間'" do
          let(:params) {{params: {period: "月間"}}}

          context "レスポンス" do
            it "ステータスコード200を返却し、:showテンプレートをrenderされる。また、自動でparams['period']に'本日'がセットされる" do
              aggregate_failures do
                expect(response).to have_http_status 200
                expect(response).to render_template :show
                expect(controller.params["period"]).to eq "月間"
              end
            end
          end

          context "インスタンス変数" do
            it "正しいインスタンス変数がセットされていること" do
              aggregate_failures do
                expect(assigns(:talk_count)).to eq 3
                expect(assigns(:get_phone_number_count)).to eq 0
                expect(assigns(:date_count)).to eq 0
                expect(assigns(:instant_sex_count)).to eq 0
                expect(assigns(:sex_on_first_date_count)).to eq 0
                expect(assigns(:sex_on_second_date_count)).to eq 0
              end
            end
          end
        end

        context "params['period'] = '全期間'" do
          let(:params) {{params: {period: "全期間"}}}

          context "レスポンス" do
            it "ステータスコード200を返却し、:showテンプレートをrenderされる。また、自動でparams['period']に'本日'がセットされる" do
              aggregate_failures do
                expect(response).to have_http_status 200
                expect(response).to render_template :show
                expect(controller.params["period"]).to eq "全期間"
              end
            end
          end

          context "インスタンス変数" do
            it "正しいインスタンス変数がセットされていること" do
              aggregate_failures do
                expect(assigns(:talk_count)).to eq 4
                expect(assigns(:get_phone_number_count)).to eq 0
                expect(assigns(:date_count)).to eq 0
                expect(assigns(:instant_sex_count)).to eq 0
                expect(assigns(:sex_on_first_date_count)).to eq 0
                expect(assigns(:sex_on_second_date_count)).to eq 0
              end
            end
          end
        end
      end

      context "paramsなし" do
        before do
          create(:activity, activity_type: create(:activity_type, :talk), created_at: 1.week.ago, user: user)
          create(:activity, activity_type: create(:activity_type, :talk), created_at: 1.minute.ago, user: user)
          create(:activity, activity_type: create(:activity_type, :date), created_at: 1.minute.ago, user: user)
          get :show
        end

        context "レスポンス" do
          it "ステータスコード200を返却し、:showテンプレートをrenderされる。また、自動でparams['period']に'本日'がセットされる" do
            aggregate_failures do
              expect(response).to have_http_status 200
              expect(response).to render_template :show
              expect(controller.params["period"]).to eq "本日"
            end
          end
        end

        context "インスタンス変数" do
          it "正しいインスタンス変数がセットされていること" do
            aggregate_failures do
              expect(assigns(:talk_count)).to eq 1
              expect(assigns(:get_phone_number_count)).to eq 0
              expect(assigns(:date_count)).to eq 1
              expect(assigns(:instant_sex_count)).to eq 0
              expect(assigns(:sex_on_first_date_count)).to eq 0
              expect(assigns(:sex_on_second_date_count)).to eq 0
            end
          end
        end
      end
    end

    context "未ログインユーザー" do
      before {get :show}
      it "ログインページにリダイレクトされること" do
        aggregate_failures do
          expect(response).to have_http_status 302
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe "POST #create" do
    context "ログインユーザー" do
      let(:params) do
        {
          params: {
            activity_type_id: activity_type_id
          }
        }
      end
      let(:activity_type_id) {create(:activity_type, :talk).id.to_s}

      before {sign_in user}
      
      context "正常形" do
        let(:activity_type_id) {create(:activity_type, :talk).id.to_s}

        context "何かしらのランキングが開催中の場合" do
          let!(:ranking) {create(:ranking, :hourly_activity_ranking)}

          it "該当のActivityカウントが１増える && 開催中のRankingのエントリーの数が１増える && カウンターページにリダイレクトされる" do
            aggregate_failures do
              expect {
                post :create, params
              }.to(
                change(Activity, :count).by(1)
                .and change(ranking.ranking_entries, :count).by(1)
              )
              expect(response).to redirect_to activities_path
            end
          end
        end

        context "ランキングが未開催の場合" do
          it "該当のActivityカウントが１増える && RankingEntryの数は増えない && カウンターページにリダイレクトされる" do
            aggregate_failures do
              expect {
                post :create, params
              }.to(
                change(Activity, :count).by(1)
                .and change(RankingEntry, :count).by(0)
              )
              expect(response).to redirect_to activities_path
            end
          end
        end
      end

      context "異常形" do
        let(:activity_type_id) {"23"} # 存在しないID

        it "バリデーションに引っかかった場合はActivityが作成されず、適切なflash[:error]メッセージとともにカウンターページにリダイレクトされること" do
          aggregate_failures do
            expect {post :create, params}.not_to change(Activity, :count)
            expect(flash[:error]).to eq "不正な操作です。もう一度やり直してください。"
            expect(response).to redirect_to activities_path
          end
        end
      end
    end
    
    context "未ログインユーザー" do
      before {post :create}

      it "ログインページにリダイレクトされること" do
        aggregate_failures do
          expect(response).to have_http_status 302
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "ログインユーザー" do
      let(:user) {create(:user, :with_single_talk_activities)}
      let!(:ranking) {create(:ranking, :hourly_activity_ranking)}
      let(:params) do
        {
          params: {
            activity_type_id: create(:activity_type, :talk).id.to_s
          }
        }
      end
      before {sign_in user}

      context "正常形" do
        context "Activityの削除によってランキングのエントリー資格を喪失する場合" do
          # 例えば、声かけのカウントによって、開催中のランキングへのエントリーが済んだが、すぐにカウントを取り消した場合はエントリー資格を喪失する
          let!(:user) {create(:user, :with_single_talk_activity)}

          it "該当のActivityカウントが１減る && 参加していたRankingのエントリーが削除される && カウンターページにリダイレクトされる" do
            aggregate_failures do
              expect {
                delete :destroy, params
              }.to(
                change(Activity, :count).by(-1)
                .and change(ranking.ranking_entries, :count).from(1).to(0)
              )
              expect(response).to redirect_to activities_path
            end
          end
        end

        context "Activityの削除をしてもランキングのエントリー資格を維持できる場合" do
          let(:user) {create(:user, :with_three_talk_activities)}

          it "該当のActivityカウントが１減る && 参加していたランキングのエントリーが維持される && カウンターページにリダイレクトされる" do
            aggregate_failures do
              expect(ranking.ranking_entries.count).to eq 1
              expect {
                delete :destroy, params
              }.to(
                change(Activity, :count).by(-1)
                .and change(ranking.ranking_entries, :count).by(0)
              )
              expect(response).to redirect_to activities_path
            end
          end
        end
      end

      context "異常形" do
        let(:user) {create(:user)} # Activityなし

        it "該当のActivityが存在しない場合は、適切なflash[:error]とともに、カウンターページにリダイレクトされること" do
          aggregate_failures do
            expect {delete :destroy, params}.not_to change(Activity, :count)
            expect(flash[:error]).to eq "不正な操作です。もう一度やり直してください。"
            expect(response).to redirect_to activities_path
          end
        end
      end
    end

    context "未ログインユーザー" do
      let(:params) do
        {
          params: {
            activity_type_id: create(:activity_type, :talk).id.to_s
          }
        }
      end
      before {delete :destroy, params}

      it "ログインページにリダイレクトされること" do
        aggregate_failures do
          expect(response).to have_http_status 302
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
