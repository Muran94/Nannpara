# == Schema Information
#
# Table name: recruitments
#
#  id                                   :integer          not null, primary key
#  title                                :string
#  description                          :text
#  event_date                           :datetime
#  venue                                :string
#  user_id                              :integer
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  prefecture_code                      :integer
#  closed                               :boolean          default(FALSE)
#  linked_with_kanto_nanpa_messageboard :boolean
#  kanto_nanpa_messageboard_delete_key  :string
#

require 'rails_helper'

RSpec.describe Recruitment, type: :model do
  context 'バリデーションテスト' do
    context 'title' do
      context 'presenceチェック' do
        it 'titleが 空 か nil の場合バリデーションに引っかかる' do
          aggregate_failures do
            expect(build_stubbed(:recruitment, title: '').valid?).to be_falsy
            expect(build_stubbed(:recruitment, title: nil).valid?).to be_falsy
          end
        end
        it 'titleが 空 でも nil でもなければバリデーションに引っかからない' do
          expect(build_stubbed(:recruitment, title: 'タイトルあり').valid?).to be_truthy
        end
      end

      context 'lengthチェック' do
        it 'titleの長さが 65文字以上 ならバリデーションに引っかかる' do
          expect(build_stubbed(:recruitment, title: '*' * (Recruitment::MAXIMUM_TITLE_LENGTH + 1)).valid?).to be_falsy
        end
        it 'titleの長さが 64文字以下 ならバリデーションに引っかからない' do
          aggregate_failures do
            expect(build_stubbed(:recruitment, title: '*' * Recruitment::MAXIMUM_TITLE_LENGTH).valid?).to be_truthy
            expect(build_stubbed(:recruitment, title: '*' * (Recruitment::MAXIMUM_TITLE_LENGTH - 1)).valid?).to be_truthy
          end
        end
      end
    end

    context 'description' do
      context 'presenceチェック' do
        it 'descriptionが 空 か nil の場合バリデーションに引っかかる' do
          aggregate_failures do
            expect(build_stubbed(:recruitment, description: '').valid?).to be_falsy
            expect(build_stubbed(:recruitment, description: nil).valid?).to be_falsy
          end
        end
        it 'descriptionが 空 でも nil でもなければバリデーションに引っかからない' do
          expect(build_stubbed(:recruitment, description: 'よろしくお願いいたします！').valid?).to be_truthy
        end
      end

      context 'lengthチェック' do
        it 'descriptionの長さが 1025文字以上 ならバリデーションに引っかかる' do
          expect(build_stubbed(:recruitment, description: '*' * (Recruitment::MAXIMUM_DESCRIPTION_LENGTH + 1)).valid?).to be_falsy
        end
        it 'descriptionの長さが 1024文字以下 ならバリデーションに引っかからない' do
          aggregate_failures do
            expect(build_stubbed(:recruitment, description: '*' * Recruitment::MAXIMUM_DESCRIPTION_LENGTH).valid?).to be_truthy
            expect(build_stubbed(:recruitment, description: '*' * (Recruitment::MAXIMUM_DESCRIPTION_LENGTH - 1)).valid?).to be_truthy
          end
        end
      end
    end

    context 'prefecture_code' do
      context 'presenceチェック' do
        it 'prefecture_codeが 空 か nil の場合バリデーションに引っかかる' do
          aggregate_failures do
            expect(build_stubbed(:recruitment, prefecture_code: '').valid?).to be_falsy
            expect(build_stubbed(:recruitment, prefecture_code: nil).valid?).to be_falsy
          end
        end
      end

      context 'inclusionチェック' do
        it 'prefecture_codeが 1 から 47 のどれにも含まれない場合バリデーションに引っかかる' do
          aggregate_failures do
            expect(build_stubbed(:recruitment, prefecture_code: 0).valid?).to be_falsy
            expect(build_stubbed(:recruitment, prefecture_code: '0').valid?).to be_falsy
            expect(build_stubbed(:recruitment, prefecture_code: 48).valid?).to be_falsy
            expect(build_stubbed(:recruitment, prefecture_code: '48').valid?).to be_falsy
            expect(build_stubbed(:recruitment, prefecture_code: 'よんじゅうはち').valid?).to be_falsy
          end
        end
        it 'prefecture_codeが 1 から 47 までのどれかの値であればバリデーションに引っかからない' do
          aggregate_failures do
            expect(build_stubbed(:recruitment, prefecture_code: 13).valid?).to be_truthy
            expect(build_stubbed(:recruitment, prefecture_code: '13').valid?).to be_truthy
          end
        end
      end
    end

    context 'venue' do
      context 'lengthチェック' do
        it 'venueの長さが 17文字以上 ならバリデーションに引っかかる' do
          expect(build_stubbed(:recruitment, venue: '*' * (Recruitment::MAXIMUM_VENUE_LENGTH + 1)).valid?).to be_falsy
        end
        it 'venueの長さが 16文字以下 ならバリデーションに引っかからない' do
          expect(build_stubbed(:recruitment, venue: '*' * Recruitment::MAXIMUM_VENUE_LENGTH).valid?).to be_truthy
          expect(build_stubbed(:recruitment, venue: '*' * (Recruitment::MAXIMUM_VENUE_LENGTH - 1)).valid?).to be_truthy
        end
      end
    end

    context 'event_date' do
      context '_event_date_cannot_be_pastチェック' do
        it 'event_dateの日時が 過去 または 現在 の場合、バリデーションに引っかかり、正しいエラーメッセージを持つ' do
          aggregate_failures do
            recruitment = build_stubbed(:recruitment, event_date: 1.day.ago) # event_dateが過去のRecruitment
            expect(recruitment.valid?).to be_falsy
            expect(recruitment.errors.messages[:event_date]).to match_array '開催日時に過去の日時を指定することはできません。'

            recruitment = build_stubbed(:recruitment, event_date: Time.zone.now) # event_dateが現在のRecruitment
            expect(recruitment.valid?).to be_falsy
            expect(recruitment.errors.messages[:event_date]).to match_array '開催日時に過去の日時を指定することはできません。'
          end
        end
        it 'event_dateの日時が 未来 の場合、バリデーションに引っかからない' do
          expect(build_stubbed(:recruitment, event_date: 1.day.from_now).valid?).to be_truthy
        end
      end
    end
  end

  context "コールバックテスト" do
    describe "#_prepare_kanto_nanpa_messageboard_delete_key" do
      let(:recruitment) {build(:recruitment, kanto_nanpa_messageboard_delete_key: "", linked_with_kanto_nanpa_messageboard: true)}

      it "kanto_nanpa_messageboard_delete_keyが空のまま入力された場合は、６桁の整数値を自動で生成し補完する" do
        aggregate_failures do
          expect(recruitment.kanto_nanpa_messageboard_delete_key).to eq ""
          recruitment.save(validate: false)
          expect(recruitment.kanto_nanpa_messageboard_delete_key).to match(/^\d{6}$/)
        end
      end
    end
  end

  context 'メソッドテスト' do
    context '#owner?' do
      let(:owner) { build_stubbed(:user, email: 'sample1@gmail.com') }
      let(:not_owner) { build_stubbed(:user, email: 'sample2@gmail.com') }
      let(:recruitment) { build_stubbed(:recruitment, user: owner) }

      it '自分の投稿ならtrueを返す && 自分の投稿でなければfalseを返す' do
        aggregate_failures do
          expect(recruitment.owner?(owner)).to be_truthy
          expect(recruitment.owner?(not_owner)).to be_falsy
        end
      end
    end
  end
end
