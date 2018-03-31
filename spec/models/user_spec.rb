# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  name                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  introduction           :text
#  experience             :string
#  age                    :integer
#  prefecture_code        :integer
#

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'バリデーションテスト' do
    context 'name' do
      context 'uniquenessチェック' do
        it 'すでに同じ名前が使用されている場合はバリデーションに引っかかり 存在しない場合は引っかからない' do
          aggregate_failures do
            user = build(:user, name: "spider")
            expect(user.valid?).to be_truthy
            user.save
            expect(build_stubbed(:user, name: "spider").valid?).to be_falsy
          end
        end
      end
      context 'presenceチェック' do
        it 'nameが 空文字 か nil ならバリデーションに引っかかる' do
          aggregate_failures do
            expect(build_stubbed(:user, name: '').valid?).to be_falsy
            expect(build_stubbed(:user, name: nil).valid?).to be_falsy
          end
        end
        it 'nameが 空文字 でも nil でもないならバリデーションに引っかからない' do
          expect(build_stubbed(:user, name: '初級ナンパ師').valid?).to be_truthy
        end
      end

      context 'lengthチェック' do
        it 'nameの長さが 65文字以上 ならバリデーションに引っかかる' do
          expect(build_stubbed(:user, name: '*' * (User::MAXIMUM_NAME_LENGTH + 1)).valid?).to be_falsy
        end
        context 'バリデーションに引っかからない場合' do
          it 'nameの長さが 64文字以下 であればバリデーションに引っかからない' do
            aggregate_failures do
              expect(build_stubbed(:user, name: '*' * User::MAXIMUM_NAME_LENGTH).valid?).to be_truthy
              expect(build_stubbed(:user, name: '*' * (User::MAXIMUM_NAME_LENGTH - 1)).valid?).to be_truthy
            end
          end
        end
      end

      context 'exclusionチェック' do
        it '特定の値を持つ場合はバリデーションに引っかかること 持たない場合はバリデーションに引っかからない' do
          aggregate_failures do
            expect(build_stubbed(:user, name: "南原さん").valid?).to be_falsy
            expect(build_stubbed(:user, name: "南原").valid?).to be_falsy
            expect(build_stubbed(:user, name: "管理人").valid?).to be_falsy
            expect(build_stubbed(:user, name: "一般人").valid?).to be_truthy
          end
        end
      end
    end

    context 'age' do
      context 'inclusionチェック' do
        it "ageが#{User::MINIMUM_AGE}歳から#{User::MAXIMUM_AGE}歳に含まれない場合はバリデーションに引っかかる" do
          aggregate_failures do
            expect(build(:user, age: User::MINIMUM_AGE - 1).valid?).to be_falsy
            expect(build(:user, age: User::MAXIMUM_AGE + 1).valid?).to be_falsy
          end
        end
        it "ageが #{User::MINIMUM_AGE}歳以上、#{User::MAXIMUM_AGE}歳以下、または、空（"" or nil) であればバリデーションに引っかからない" do
          aggregate_failures do
            expect(build(:user, age: User::MINIMUM_AGE).valid?).to be_truthy
            expect(build(:user, age: User::MINIMUM_AGE + 10).valid?).to be_truthy
            expect(build(:user, age: User::MAXIMUM_AGE).valid?).to be_truthy
            expect(build(:user, age: "").valid?).to be_truthy
            expect(build(:user, age: nil).valid?).to be_truthy
          end
        end
      end
    end

    context "name" do
      context "サイズチェック" do
        let(:user) {build_stubbed(:user, image: nil)}
        it "画像サイズが5MBを超えたらバリデーションに引っかかり、以下なら引っかからない" do
          aggregate_failures do
            user.image = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/image/large_sample_image.jpg'))
            expect(user.valid?).to be_falsy
            user.image = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/image/sample_image.jpg'))
            expect(user.valid?).to be_truthy
          end
        end
      end
    end
  end
end
