require 'rails_helper'

describe RecruitmentDecorator do
  let(:recruitment) { create(:recruitment).extend RecruitmentDecorator }

  describe '#format_created_at && #format_event_date' do
    it %(整形された値が返ってくること) do
      aggregate_failures do
        expect(recruitment.format_created_at).to eq recruitment.created_at.strftime('%Y年%m月%d日 %H時%M分')
        expect(recruitment.format_event_date).to eq recruitment.event_date.strftime('%Y年%m月%d日 %H時%M分')
      end
    end
  end
end
