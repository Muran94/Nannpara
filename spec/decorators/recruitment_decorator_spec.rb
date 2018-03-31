require 'rails_helper'

describe RecruitmentDecorator do
  let(:recruitment) { create(:recruitment).extend RecruitmentDecorator }

  describe "#format_image_url" do
    context "募集主がプロフィール画像を設定している場合" do
      it "返ってくる画像の種類がただしい" do
        aggregate_failures do
          expect(recruitment.format_image_url).to eq recruitment.user.image_url
          expect(recruitment.format_image_url("thumb")).to eq recruitment.user.image.thumb.url
          expect(recruitment.format_image_url("something_else")).to eq "no_user_image.png"
        end
      end
    end
    context "募集主がプロフィール画像を設定していない場合" do
      let(:user) {create(:user, image: nil)}
      let(:recruitment) {build(:recruitment, user: user).extend RecruitmentDecorator}

      it "画像がない場合はno_user_image.pngを返す" do
        expect(recruitment.format_image_url).to eq "no_user_image.png"
      end
    end
  end

  describe '#format_created_at && #format_event_date' do
    it %(整形された値が返ってくること) do
      aggregate_failures do
        expect(recruitment.format_created_at).to eq recruitment.created_at.strftime('%Y年%m月%d日 %H時%M分')
        expect(recruitment.format_event_date).to eq recruitment.event_date.strftime('%Y年%m月%d日 %H時%M分')
      end
    end
  end

  describe "#format_short_created_at && #format_short_event_date" do
    it "整形された値が返ってくること" do
      aggregate_failures do
        expect(recruitment.format_short_created_at).to eq recruitment.created_at.strftime('%m/%d %H:%M')
        expect(recruitment.format_short_event_date).to eq recruitment.event_date.strftime('%m/%d %H:%M')
      end
    end
  end

  describe "#format_event_venue" do
    it "都道府県と開催場所を繋げた形で返すこと" do
      expect(recruitment.format_event_venue). to eq %(#{recruitment.prefecture.name} > #{recruitment.venue})
    end
  end

  describe "#shortened_description" do
    let(:recruitment) {build_stubbed(:recruitment).extend RecruitmentDecorator}
    it "descriptionの長さが256文字を超えたら省略、以下であればそのまま" do
      aggregate_failures do
        recruitment.description = "a" * 257
        expect(recruitment.shortened_description).to eq "#{recruitment.description[0..256]} ..."
        recruitment.description = "a" * 255
        expect(recruitment.shortened_description).to eq recruitment.description
      end
    end
  end
end
