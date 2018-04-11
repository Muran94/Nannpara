require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #index" do
    before {get :index}

    context "レスポンス" do
      it "レスポンスコード200を返却 && :indexテンプレートをrender" do
        aggregate_failures do
          expect(response).to have_http_status 200
          expect(response).to render_template :index
        end
      end
    end

    context "インスタンス変数" do
      let!(:first_recruitment) {create(:recruitment, event_date: 1.day.from_now.to_date, closed_at: nil)}
      let!(:second_recruitment) {create(:recruitment, event_date: 2.days.from_now.to_date, closed_at: nil)}
      let!(:third_recruitment) {create(:recruitment, event_date: 3.days.from_now.to_date, closed_at: nil)}
      let!(:closed_recruitment) {create(:recruitment, event_date: 4.days.from_now.to_date, closed_at: Time.zone.now)}
      let(:first_blog_article) {create(:blog_article, created_at: 1.day.ago)}
      let(:second_blog_article) {create(:blog_article, created_at: 2.day.ago)}
      let(:third_blog_article) {create(:blog_article, created_at: 3.day.ago)}
      let(:fourth_blog_article) {create(:blog_article, created_at: 4.day.ago)}
      it "@recruitmentsとblog_articlesに関して、正しいコレクションを取得できている" do
        aggregate_failures do
          expect(assigns(:recruitments)).to eq [first_recruitment, second_recruitment, third_recruitment]
          expect(assigns(:blog_articles)).to eq [first_blog_article, second_blog_article, third_blog_article]
        end
      end
    end
  end
end
