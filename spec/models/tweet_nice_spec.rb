# == Schema Information
#
# Table name: tweet_nices
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  tweet_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe TweetNice, type: :model do
  context "バリデーションテスト" do
    context "user_id && tweet_id" do
      let(:user) {create(:user)}
      let(:other_user) {create(:user)}
      let(:tweet) {create(:tweet)}
      let(:other_tweet) {create(:tweet)}

      before {create(:tweet_nice, user: user, tweet: tweet)}

      context "uniqueness" do
        context "同じ組み合わせのTweetNiceがある場合" do
          it "バリデーションに引っかかること" do
            expect(build(:tweet_nice, user: user, tweet: tweet).valid?).to be_falsy
          end
        end

        context "同じ組み合わせのTweetNiceがない場合" do
          it "バリデーションに引っかからないこと" do
            aggregate_failures do
              expect(build(:tweet_nice, user: other_user, tweet: tweet).valid?).to be_truthy
              expect(build(:tweet_nice, user: user, tweet: other_tweet).valid?).to be_truthy
              expect(build(:tweet_nice, user: other_user, tweet: other_tweet).valid?).to be_truthy
            end
          end
        end
      end
    end
  end
end
