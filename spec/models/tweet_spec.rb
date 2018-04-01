require 'rails_helper'

RSpec.describe Tweet, type: :model do
  context "バリデーションテスト" do
    context "content" do
      context "presenceチェック" do
        it "contentが 空 か nil の場合はバリデーションに引っかかる, そうでなければ通る" do
          aggregate_failures do
            expect(build_stubbed(:tweet, content: "地蔵中。やばい。").valid?).to be_truthy
            expect(build_stubbed(:tweet, content: "").valid?).to be_falsy
            expect(build_stubbed(:tweet, content: nil).valid?).to be_falsy
          end
        end
      end

      context "lengthチェック" do
        it "contentの長さが#{Tweet::MAXIMUM_CONTENT_LENGTH}を超えた場合はバリデーションに引っかかり、以下であれば引っかからない" do
          aggregate_failures do
            expect(build_stubbed(:tweet, content: "a" * (Tweet::MAXIMUM_CONTENT_LENGTH + 1)).valid?).to be_falsy
            expect(build_stubbed(:tweet, content: "a" * Tweet::MAXIMUM_CONTENT_LENGTH).valid?).to be_truthy
            expect(build_stubbed(:tweet, content: "a" * (Tweet::MAXIMUM_CONTENT_LENGTH - 1)).valid?).to be_truthy
          end
        end
      end
    end
  end
end
