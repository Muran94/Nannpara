require 'rails_helper'

RSpec.describe ServiceController, type: :controller do
  describe 'GET #inquiry' do
    before { get :inquiry }
    context 'レスポンス' do
      it 'レスポンスステータス200を返却 && :inquiryテンプレートをrenderすること' do
        aggregate_failures do
          expect(response).to have_http_status 200
          expect(response).to render_template :inquiry
        end
      end
    end
  end
end
