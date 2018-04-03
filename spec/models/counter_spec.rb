require 'rails_helper'

RSpec.describe Counter, type: :model do
  context 'バリデーション' do
    context 'counter_type' do
      context 'inclusionチェック' do
        context "正常系 - #{Counter::COUNTER_TYPE_AVAILABLE_VALUES.join(',')}のどれか" do
          let(:speak_counter) { build_stubbed(:counter, counter_type: '声かけ') }
          let(:tel_counter) { build_stubbed(:counter, counter_type: 'バンゲ') }
          let(:sex_counter) { build_stubbed(:counter, counter_type: '即') }
          let(:some_other_counter) { build_stubbed(:counter, counter_type: 'チョコバー') }

          it "#{Counter::COUNTER_TYPE_AVAILABLE_VALUES.join(',')}に含まれる場合はバリデーションに引っかからない、含まれない場合はバリデーションに引っかかる" do
            aggregate_failures do
              expect(speak_counter.valid?).to be_truthy
              expect(tel_counter.valid?).to be_truthy
              expect(sex_counter.valid?).to be_truthy
              expect(some_other_counter.valid?).to be_falsy
            end
          end
        end
      end
    end
  end
end
