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

  describe %(#thumb_image_url) do
    let(:user) { create(:user) }
    let(:recruitment) { create(:recruitment, user: user).extend RecruitmentDecorator }

    it %(userが画像を持っていれば その画像URL を、持っていなければ "no_user_image.png" を返す) do
      aggregate_failures do
        expect(recruitment.users_thumb_image_url).to eq recruitment.user.image.thumb.url
        user.image = nil
        user.save
        expect(recruitment.users_thumb_image_url).to eq 'no_user_image.png'
      end
    end
  end
end
