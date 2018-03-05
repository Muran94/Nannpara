require 'rails_helper'

RSpec.describe User, type: :model do
  context "バリデーションテスト" do
    context "name" do
      context "presenceチェック" do
        it "nameが 空文字 か nil ならバリデーションに引っかかる" do
          aggregate_failures do
            expect(build(:user, name: "").valid?).to be_falsy
            expect(build(:user, name: nil).valid?).to be_falsy
          end
        end
        it "nameが 空文字 でも nil でもないならバリデーションに引っかからない" do
          expect(build(:user, name: "初級ナンパ師").valid?).to be_truthy
        end
      end

      context "lengthチェック" do
        it "nameの長さが 65文字以上 ならバリデーションに引っかかる" do
          expect(build(:user, name: "*" * 65).valid?).to be_falsy
        end
        context "バリデーションに引っかからない場合" do
          it "nameの長さが 64文字以下 であればバリデーションに引っかからない" do
            aggregate_failures do
              expect(build(:user, name: "*" * 64).valid?).to be_truthy
              expect(build(:user, name: "*" * 63).valid?).to be_truthy
            end
          end
        end
      end
    end
  end
end
