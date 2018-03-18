require 'rails_helper'

describe MessageDecorator do
  let(:message) { Message.new.extend MessageDecorator }
  subject { message }
  it { should be_a Message }

  describe '#format_user_name' do
    context 'userを持つ場合（ログインユーザーによる投稿）' do
      let(:user) { build(:user) }
      let(:message) { build(:message, user: user).extend MessageDecorator }

      it 'ユーザー名を返す' do
        expect(message.format_user_name).to eq message.user.name
      end
    end

    context 'userを持たない場合（未ログインユーザーによる投稿）' do
      let(:message) { build(:message).extend MessageDecorator }

      it '「南原さん」を返す' do
        expect(message.format_user_name).to eq '南原さん'
      end
    end
  end

  describe %(#thumb_image_url) do
    context %(登録ユーザーによるメッセージの場合) do
      let(:user) {create(:user)}
      let(:message) { create(:message, user: user).extend RecruitmentDecorator }

      it %(userが画像を持っていれば その画像URL を、持っていなければ "no_user_image.png" を返す) do
        aggregate_failures do
          expect(message.users_thumb_image_url).to eq message.user.image.thumb.url
          user.image = nil
          user.save
          expect(message.users_thumb_image_url).to eq "no_user_image.png"
        end
      end
    end
    context %(未登録ユーザーによるメッセージの場合) do
      let(:message) { create(:message).extend RecruitmentDecorator }

      it %("no_user_image.png" を返す) do
        expect(message.users_thumb_image_url).to eq "no_user_image.png"
      end
    end
  end
end
