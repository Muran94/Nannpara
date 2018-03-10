require 'rails_helper'

RSpec.describe Message, type: :model do
  context "バリデーションテスト" do
    context "message" do
      context "presenceチェック" do
        it "messageが 空文字 か nil ならバリデーションに引っかかる" do
          aggregate_failures do
            expect(build(:message, message: "").valid?).to be_falsy
            expect(build(:message, message: nil).valid?).to be_falsy
          end
        end
        context "バリデーションに引っかからない場合" do
          context "messageが 空文字 でも nil でもないならバリデーションに引っかからないこと" do
            it {expect(build(:message, message: "参加します！").valid?).to be_truthy}
          end
        end
      end

      context "lengthチェック" do
        context "バリデーションに引っかかる場合" do
          context "messageの長さが 1025文字以上 ならバリデーションに引っかかる" do
            it {expect(build(:message, message: "*" * 1025).valid?).to be_falsy}
          end
        end
        context "バリデーションに引っかからない場合" do
          it "messageの長さが 1024文字以下 ならバリデーションに引っかからない" do
            aggregate_failures do
              expect(build(:message, message: "*" * 1024).valid?).to be_truthy
              expect(build(:message, message: "*" * 1023).valid?).to be_truthy
            end
          end
        end
      end
    end
  end
end
