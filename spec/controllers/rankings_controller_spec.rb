require 'rails_helper'

RSpec.describe RankingsController, type: :controller do

  describe "GET #index" do
    let!(:hourly_activity_ranking) {create(:ranking, :hourly_activity_ranking)}
    let!(:daily_activity_ranking) {create(:ranking, :daily_activity_ranking)}
    let!(:monthly_activity_ranking) {create(:ranking, :monthly_activity_ranking)}

    before {get :index}

    context "レスポンス" do
      it "ステータスコード200を返却 && indexテンプレートがrenderされる" do
        aggregate_failures do
          expect(response).to have_http_status 200
          expect(response).to render_template :index
        end
      end
    end

    context "インスタンス変数" do
      it "正しいインスタンス変数がセットされている" do
        aggregate_failures do
          expect(assigns(:hourly_activity_ranking)).to eq hourly_activity_ranking
          expect(assigns(:hourly_activity_ranking_entry_number)).to eq hourly_activity_ranking.users.count
          expect(assigns(:hourly_activity_top_three_users)).to eq hourly_activity_ranking.top_three_rankers
          expect(assigns(:daily_activity_ranking)).to eq daily_activity_ranking
          expect(assigns(:daily_activity_ranking_entry_number)).to eq daily_activity_ranking.users.count
          expect(assigns(:daily_activity_top_three_users)).to eq daily_activity_ranking.top_three_rankers
          expect(assigns(:monthly_activity_ranking)).to eq monthly_activity_ranking
          expect(assigns(:monthly_activity_ranking_entry_number)).to eq monthly_activity_ranking.users.count
          expect(assigns(:monthly_activity_top_three_users)).to eq monthly_activity_ranking.top_three_rankers
          
        end
      end
    end
  end

  describe "GET #show" do
    let(:hourly_activity_ranking) {create(:ranking, :hourly_activity_ranking)}
    let(:params) {{params: {id: hourly_activity_ranking.id}}}

    before {get :show, params}

    context "レスポンス" do
      it "ステータスコード200を返却 && indexテンプレートがrenderされる" do
        aggregate_failures do
          expect(response).to have_http_status 200
          expect(response).to render_template :show
        end
      end
    end

    context "インスタンス変数" do
      it "正しいインスタンス変数がセットされている" do
        aggregate_failures do
          expect(assigns(:ranking)).to eq hourly_activity_ranking
          expect(assigns(:ranking_user_ranking)).to eq hourly_activity_ranking.user_ranking
        end
      end
    end
  end
end
