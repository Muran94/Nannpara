require 'rails_helper'

describe MessageDecorator do
  let(:message) { Message.new.extend MessageDecorator }
  subject { message }
  it { should be_a Message }

  describe '#format_user_name' do
    context 'userを持つ場合（ログインユーザーによる投稿）' do
      let(:user) { build_stubbed(:user) }
      let(:message) { build_stubbed(:message, user: user).extend MessageDecorator }

      it 'ユーザー名を返す' do
        expect(message.format_user_name).to eq message.user.name
      end
    end

    context 'userを持たない場合（未ログインユーザーによる投稿）' do
      let(:message) { build_stubbed(:message).extend MessageDecorator }

      it '「南原さん」を返す' do
        expect(message.format_user_name).to eq '南原さん'
      end
    end
  end

  describe '#users_thumb_image_url' do
    context 'userを持つ場合' do
      context 'userがプロフィール画像を登録している場合' do
        let(:user) { create(:user) }
        let(:message) { build_stubbed(:message, user: user).extend MessageDecorator }

        it '適切な画像を返すこと' do
          expect(message.users_thumb_image_url).to eq message.user.image.thumb.url
        end
      end

      context 'userがプロフィール画像を登録していない場合' do
        let(:user) { create(:user, image: nil) }
        let(:message) { build_stubbed(:message, user: user).extend MessageDecorator }

        it "#{Settings.image.no_user_image_file_name}を返す" do
          expect(message.users_thumb_image_url).to eq Settings.image.no_user_image_file_name
        end
      end
    end
    context 'userを持たない場合' do
      let(:message) { build_stubbed(:message).extend MessageDecorator }

      it "#{Settings.image.no_user_image_file_name}を返す" do
        expect(message.users_thumb_image_url).to eq Settings.image.no_user_image_file_name
      end
    end
  end
end
