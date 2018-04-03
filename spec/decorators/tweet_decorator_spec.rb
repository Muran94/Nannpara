require 'rails_helper'

describe TweetDecorator do
  let(:tweet) { build(:tweet).extend TweetDecorator }

  describe '#format_image_url' do
    context 'つぶやき主がプロフィール画像を設定している場合' do
      it '返ってくる画像の種類がただしい' do
        aggregate_failures do
          expect(tweet.format_image_url).to eq tweet.user.image_url
          expect(tweet.format_image_url('thumb')).to eq tweet.user.image.thumb.url
          expect(tweet.format_image_url('something_else')).to eq 'no_user_image.png'
        end
      end
    end
    context '募集主がプロフィール画像を設定していない場合' do
      let(:user) { create(:user, image: nil) }
      let(:tweet) { build(:tweet, user: user).extend TweetDecorator }

      it '画像がない場合はno_user_image.pngを返す' do
        expect(tweet.format_image_url).to eq 'no_user_image.png'
      end
    end
  end
end
