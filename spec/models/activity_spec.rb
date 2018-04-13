# == Schema Information
#
# Table name: activities
#
#  id                        :integer          not null, primary key
#  activity_type_id          :integer
#  obtained_experience_point :integer          default(0)
#  user_id                   :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

require 'rails_helper'

RSpec.describe Activity, type: :model do

  context "バリデーションテスト" do
    context "activity_type_id" do
      context "inclusion" do
        it "登録されているActivityTypeのどれかのIDであればバリデーションに引っかからず、含まれていなければバリデーションに引っかかる" do
          aggregate_failures do
            ActivityType.pluck(:id).each do |activity_type_id|
              expect(build_stubbed(:activity, activity_type_id: activity_type_id)).to be_valid
            end
            expect(build_stubbed(:activity, activity_type_id: 108723)).not_to be_valid
            expect(build_stubbed(:activity, activity_type_id: "AZ87I7aospjfaA")).not_to be_valid
          end
        end
      end
    end
  end

  context "コールバックテスト" do
    let(:activity_type) {ActivityType.find_by_name_ja("声かけ")}

    context "before_create" do
      context "#_set_obtained_experience_point" do
        let(:activity) {build(:activity, activity_type: activity_type)}

        it "Activityを登録すると、ActivityTypeに基づいて付与された経験値をobtained_experience_pointに記録" do
          aggregate_failures do
            expect(activity.obtained_experience_point).to eq 0
            activity.save
            activity.reload
            expect(activity.obtained_experience_point).to eq activity_type.experience_point
          end
        end
      end
    end

    context "after_create" do
      context "#_update_users_experience_point" do
        let(:user) {create(:user, experience_point: default_experience_point)}
        let(:default_experience_point) {0}

        it "Activityを作成したあとに、Userのexperience_pointが増加していること" do
          aggregate_failures do
            expect(user.experience_point).to eq default_experience_point
            create(:activity, activity_type: activity_type, user: user)
            user.reload
            expect(user.experience_point).to eq (default_experience_point + activity_type.experience_point)
          end
        end
      end

      context "#_entry_activity_rankings" do
        context "開催中のランキングがある場合" do
          let!(:monthly_activity_ranking) {create(:ranking, :monthly_activity_ranking)}
          let!(:daily_activity_ranking) {create(:ranking, :daily_activity_ranking)}
          let!(:hourly_activity_ranking) {create(:ranking, :hourly_activity_ranking)}

          context "執筆（募集orブログ）によるエントリー" do
            it "「毎時の活動ランキング」へのエントリーは完了しないが、その他の「本日の活動ランキング」と「今月の活動ランキング」への参加は完了する" do
              aggregate_failures do
                expect {
                  create(:activity, :post_recruitment_article_activity)
                }.to( 
                  change(monthly_activity_ranking.ranking_entries, :count).from(0).to(1)
                  .and change(daily_activity_ranking.ranking_entries, :count).from(0).to(1)
                  .and change(hourly_activity_ranking.ranking_entries, :count).by(0)
                )
              end
            end
          end

          context "通常のナンパ活動によるエントリー" do
            it "「毎時の活動ランキング」、「本日の活動ランキング」、「今月の活動ランキング」全てのエントリーが完了する" do
              aggregate_failures do
                expect {
                  create(:activity, :talk_activity)
                }.to( 
                  change(monthly_activity_ranking.ranking_entries, :count).from(0).to(1)
                  .and change(daily_activity_ranking.ranking_entries, :count).from(0).to(1)
                  .and change(hourly_activity_ranking.ranking_entries, :count).from(0).to(1)
                )
              end
            end
          end
        end

        context "開催中のランキングがない場合" do
          it "「毎時の活動ランキング」、「本日の活動ランキング」、「今月の活動ランキング」全てのエントリーが完了する" do
            aggregate_failures do
              expect {
                create(:activity, :talk_activity)
            }.not_to change(RankingEntry, :count)
            end
          end
        end
      end
    end

    context "after_destroy" do
      context "#_update_users_experience_point" do
        let(:user) {create(:user, :with_three_talk_activities)}
        let(:default_experience_point) {6} # 声かけ数１回２ポイント × 3 = 6ポイント

        it "Activityを削除したあとに、Userのexperience_pointが減少していること" do
          aggregate_failures do
            expect(user.experience_point).to eq default_experience_point
            user.activities.where(activity_type: activity_type).last.destroy
            user.reload
            expect(user.experience_point).to eq (default_experience_point - activity_type.experience_point)
          end
        end
      end

      context "#_cancel_entry" do
        let!(:ranking) {create(:ranking, :hourly_activity_ranking)}

        context "Activityの削除によってランキングのエントリー資格を喪失する場合" do
          # 例えば、声かけのカウントによって、開催中のランキングへのエントリーが済んだが、すぐにカウントを取り消した場合はエントリー資格を喪失する
          let!(:user) {create(:user, :with_single_talk_activity)}

          it "ランキングへのエントリーが削除（キャンセル）されること" do
            aggregate_failures do
              expect {
                user.activities.first.destroy
              }.to change(ranking.ranking_entries, :count).from(1).to(0)
            end
          end
        end

        context "Activityの削除をしてもランキングのエントリー資格を維持できる場合" do
          let!(:user) {create(:user, :with_three_talk_activities)}

          it "ランキングへのエントリーが維持されること" do
            aggregate_failures do
              expect(ranking.ranking_entries.count).to eq 1
              expect {
                user.activities.first.destroy
              }.not_to change(ranking.ranking_entries, :count)
            end
          end
        end
      end
    end
  end

  context "スコープテスト" do

  end

  context "リレーションテスト" do

  end

  context "クラスメソッドテスト" do

  end

  context "インスタンスメソッドテスト" do
    
  end
end
