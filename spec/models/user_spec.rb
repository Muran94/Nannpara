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
#  failed_attempts        :integer          default(0), not null
#  locked_at              :datetime
#  name                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  introduction           :text
#  experience             :string
#  age                    :integer
#  prefecture_code        :integer
#  image                  :string
#  direct_mail            :boolean
#  experience_point       :integer          default(0)
#  level_id               :integer          default(1)
#

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'バリデーションテスト' do
    context 'name' do
      context 'uniquenessチェック' do
        it 'すでに同じ名前が使用されている場合はバリデーションに引っかかり 存在しない場合は引っかからない' do
          aggregate_failures do
            user = build(:user, name: 'spider')
            expect(user.valid?).to be_truthy
            user.save
            expect(build_stubbed(:user, name: 'spider').valid?).to be_falsy
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
            expect(build_stubbed(:user, name: '南原さん').valid?).to be_falsy
            expect(build_stubbed(:user, name: '南原').valid?).to be_falsy
            expect(build_stubbed(:user, name: '管理人').valid?).to be_falsy
            expect(build_stubbed(:user, name: '一般人').valid?).to be_truthy
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
        it "ageが #{User::MINIMUM_AGE}歳以上、#{User::MAXIMUM_AGE}歳以下、または、空（"' or nil) であればバリデーションに引っかからない' do
          aggregate_failures do
            expect(build(:user, age: User::MINIMUM_AGE).valid?).to be_truthy
            expect(build(:user, age: User::MINIMUM_AGE + 10).valid?).to be_truthy
            expect(build(:user, age: User::MAXIMUM_AGE).valid?).to be_truthy
            expect(build(:user, age: '').valid?).to be_truthy
            expect(build(:user, age: nil).valid?).to be_truthy
          end
        end
      end
    end

    context 'name' do
      context 'サイズチェック' do
        let(:user) { build_stubbed(:user, image: nil) }
        it '画像サイズが5MBを超えたらバリデーションに引っかかり、以下なら引っかからない' do
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

  context "リレーションテスト" do
    context "#recruitments" do
      let!(:user) {create(:user, :with_recruitments)}

      it "dependent: :destroy" do
        aggregate_failures do
          expect {
            user.destroy
          }.to change(user.recruitments, :count).from(3).to(0) 
        end
      end
    end

    context "#messages" do
      let!(:user) {create(:user, :with_recruitment_message)}

      it "dependent: :destroy" do
        aggregate_failures do
          expect {
            user.destroy
          }.to change(user.messages, :count).from(1).to(0)
        end
      end
    end

    context "#activities" do
      let!(:user) {create(:user, :with_three_talk_activities)}

      it "dependent: :destroy" do
        aggregate_failures do
          expect {
            user.destroy
          }.to change(user.activities, :count).from(3).to(0)
        end
      end
    end

    context "#ranking_entries" do
      let!(:user) {create(:user, :with_three_ranking_entries)}

      it "dependent: :destroy" do
        aggregate_failures do
          expect {
            user.destroy
          }.to change(user.ranking_entries, :count).from(3).to(0)
        end
      end
    end

    context "#blog_articles" do
      let!(:user) {create(:user, :with_blog_article)}

      it "dependent: :destroy" do
        aggregate_failures do
          expect {
            user.destroy
          }.to change(user.blog_articles, :count).from(1).to(0)
        end
      end
    end

    context "#blog_comments" do
      let!(:user) {create(:user, :with_blog_comment)}

      it "dependent: :destroy" do
        aggregate_failures do
          expect {
            user.destroy
          }.to change(user.blog_comments, :count).from(1).to(0)
        end
      end
    end
  end

  context "コールバックテスト" do
    let(:user) {build(:user, level_id: 1, experience_point: 100)}

    context "#before_save" do
      context "#_update_level" do
        it "セーブをする前に、適切なレベルが設定される" do
          aggregate_failures do
            expect {
              user.save
            }.to change{user.level_id}.from(1).to(8)
          end
        end
      end
    end
  end

  xcontext "スコープテスト" do
  end

  xcontext "クラスメソッドテスト" do
  end

  context 'インスタンスメソッドテスト' do
    describe '#thumb_image_url' do
      context 'ユーザーがプロフィール画像を設定していない場合' do
        let(:user) { build_stubbed(:user, image: nil) }

        it "#{Settings.image.no_user_image_file_name}を返す" do
          expect(user.thumb_image_url).to eq Settings.image.no_user_image_file_name
        end
      end
      context 'ユーザーガプロフィール画像を設定している場合' do
        let(:user) { build_stubbed(:user) }

        it 'サムネールサイズの画像URLを返す' do
          expect(user.thumb_image_url).to eq user.image.thumb.url
        end
      end
    end

    describe "#level" do
      it "level_idと同じidを持つLevelオブジェクトを取得する" do
        aggregate_failures do
          expect(build_stubbed(:user, level_id: 1).level).to eq Level.find(1)
          expect(build_stubbed(:user, level_id: 5).level).to eq Level.find(5)
        end
      end
    end

    describe "#experience_points_required_to_level_up" do
      context "ユーザーレベルが100の場合" do
        it "レベルアップに必要な経験値として0を返す（カンスト）" do
          aggregate_failures do
            expect(build_stubbed(:user, level_id: 100).experience_points_required_to_level_up).to eq 0
          end
        end
      end

      context "ユーザーレベルが1~99の場合" do
        it "レベルアップに必要な経験値を返す" do
          aggregate_failures do
            expect(build_stubbed(:user, experience_point: 0, level_id: 1).experience_points_required_to_level_up).to eq 3
            [3, 55, 99].each do |level|
              user = build_stubbed(
                        :user,
                        experience_point: Level.find(level).required_experience_point,
                        level_id: level
                      )
              expect(user.experience_points_required_to_level_up).to eq Level.find(level + 1).required_experience_point - user.experience_point
            end
          end
        end
      end
    end
  end
end
