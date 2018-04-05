# == Schema Information
#
# Table name: tweets
#
#  id                :integer          not null, primary key
#  content           :text
#  user_id           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  tweet_nices_count :integer          default(0), not null
#

require 'rails_helper'

RSpec.describe Tweet, type: :model do
  context 'バリデーションテスト' do
    context 'content' do
      context 'presenceチェック' do
        it 'contentが 空 か nil の場合はバリデーションに引っかかる, そうでなければ通る' do
          aggregate_failures do
            expect(build_stubbed(:tweet, content: '地蔵中。やばい。').valid?).to be_truthy
            expect(build_stubbed(:tweet, content: '').valid?).to be_falsy
            expect(build_stubbed(:tweet, content: nil).valid?).to be_falsy
          end
        end
      end

      context 'lengthチェック' do
        it "contentの長さが#{Tweet::MAXIMUM_CONTENT_LENGTH}を超えた場合はバリデーションに引っかかり、以下であれば引っかからない" do
          aggregate_failures do
            expect(build_stubbed(:tweet, content: 'a' * (Tweet::MAXIMUM_CONTENT_LENGTH + 1)).valid?).to be_falsy
            expect(build_stubbed(:tweet, content: 'a' * Tweet::MAXIMUM_CONTENT_LENGTH).valid?).to be_truthy
            expect(build_stubbed(:tweet, content: 'a' * (Tweet::MAXIMUM_CONTENT_LENGTH - 1)).valid?).to be_truthy
          end
        end
      end
    end
  end

  context "tweet_nices_count" do
    context "tweet_nicesが作成された場合" do
      let(:tweet) {create(:tweet)}

      it "tweet_nices_countの値がインクリメントされる" do
        aggregate_failures do
          expect(tweet.tweet_nices_count).to eq 0
          tweet.tweet_nices.create(user: build_stubbed(:user))
          tweet.reload
          expect(tweet.tweet_nices_count).to eq 1
        end
      end
    end
    context "tweet_nicesが削除された場合" do
      let(:tweet) {create(:tweet, :with_a_single_tweet_nice)}

      it "tweet_nices_countの値がデクリメントされる" do
        aggregate_failures do
          tweet.reload
          expect(tweet.tweet_nices_count).to eq 1
          tweet.tweet_nices.first.destroy
          tweet.reload
          expect(tweet.tweet_nices_count).to eq 0
        end
      end
    end
  end
end
