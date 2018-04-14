# == Schema Information
#
# Table name: rankings
#
#  id              :integer          not null, primary key
#  ranking_type_id :integer
#  start_at        :datetime
#  end_at          :datetime
#  closed_at       :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Ranking, type: :model do

  context "バリデーションテスト" do
    context "ranking_type_id && start_at && end_at" do
      context "uniqueness" do
        it "同じ種類のランキングで、同じ開始/終了時間のものがあった場合はバリデーションに引っかかり、それ以外はバリデーションに引っかからない" do
          aggregate_failures do
            current_time = Time.zone.now
            future_time = 1.day.from_now
            ranking = build(:ranking, :hourly_activity_ranking, start_at: current_time.beginning_of_hour, end_at: current_time.end_of_hour)
            expect(ranking).to be_valid
            ranking.save
            # 同じ種類のランキングだが、同じ開始/終了時刻のものがないのでバリデーションに引っかからない
            expect(build_stubbed(:ranking, :hourly_activity_ranking, start_at: future_time.beginning_of_hour, end_at: future_time.end_of_hour)).to be_valid
            # 同じ種類で、同じ開始/終了時刻のものがすでにデータベースに存在するのでバリデーションに引っかかる
            expect(build_stubbed(:ranking, :hourly_activity_ranking, start_at: current_time.beginning_of_hour, end_at: current_time.end_of_hour)).not_to be_valid 
          end
        end
      end
    end
  end

  context "コールバックテスト" do
    context "before_create" do
      context "#_set_start_at" do
        it "ランキングの種類に応じて、適切なstart_atがセットされること" do
          aggregate_failures do
            # 「毎時の活動ランキング」
            hourly_activity_ranking = build(:ranking, :hourly_activity_ranking)
            expect(hourly_activity_ranking.start_at).to eq nil
            hourly_activity_ranking.save
            hourly_activity_ranking.reload
            expect(hourly_activity_ranking.start_at.to_s).to eq Time.zone.now.beginning_of_hour.to_s

            # 「本日の活動ランキング」
            hourly_activity_ranking = build(:ranking, :daily_activity_ranking)
            expect(hourly_activity_ranking.start_at).to eq nil
            hourly_activity_ranking.save
            hourly_activity_ranking.reload
            expect(hourly_activity_ranking.start_at.to_s).to eq Time.zone.now.beginning_of_day.to_s

            # 「今月の活動ランキング」
            hourly_activity_ranking = build(:ranking, :monthly_activity_ranking)
            expect(hourly_activity_ranking.start_at).to eq nil
            hourly_activity_ranking.save
            hourly_activity_ranking.reload
            expect(hourly_activity_ranking.start_at.to_s).to eq Time.zone.now.beginning_of_month.to_s
          end
        end
      end
      context "#_set_end_at" do
        it "ランキングの種類に応じて、適切なend_atがセットされること" do
          aggregate_failures do
            # 「毎時の活動ランキング」
            hourly_activity_ranking = build(:ranking, :hourly_activity_ranking)
            expect(hourly_activity_ranking.end_at).to eq nil
            hourly_activity_ranking.save
            hourly_activity_ranking.reload
            expect(hourly_activity_ranking.end_at.to_s).to eq Time.zone.now.end_of_hour.to_s

            # 「本日の活動ランキング」
            hourly_activity_ranking = build(:ranking, :daily_activity_ranking)
            expect(hourly_activity_ranking.end_at).to eq nil
            hourly_activity_ranking.save
            hourly_activity_ranking.reload
            expect(hourly_activity_ranking.end_at.to_s).to eq Time.zone.now.end_of_day.to_s

            # 「今月の活動ランキング」
            hourly_activity_ranking = build(:ranking, :monthly_activity_ranking)
            expect(hourly_activity_ranking.end_at).to eq nil
            hourly_activity_ranking.save
            hourly_activity_ranking.reload
            expect(hourly_activity_ranking.end_at.to_s).to eq Time.zone.now.end_of_month.to_s
          end
        end
      end
    end

    context "after_create" do
      xcontext "#_set_announce_result_job" do
        it "Rankingのend_atの時間にRankingResultAnnouncementJobをエンキューする" do
          aggregate_failures do
            hourly_activity_ranking = build(:ranking, :hourly_activity_ranking)
            expect {
              hourly_activity_ranking.save
            }.to have_enqueued_job(RankingResultAnnouncementJob).at(hourly_activity_ranking.end_at)
          end
        end
      end
    end
  end

  context "スコープテスト" do
    context "#hourly_activity_ranking" do
      let!(:monthly_activity_ranking) {create(:ranking, :monthly_activity_ranking)}
      let!(:daily_activity_ranking) {create(:ranking, :daily_activity_ranking)}
      let!(:hourly_activity_ranking) {create(:ranking, :hourly_activity_ranking)}

      it "「毎時の活動ランキング」の一覧を返す" do
        aggregate_failures do
          expect(Ranking.hourly_activity_ranking).to match_array([hourly_activity_ranking])
        end
      end
    end

    context "#daily_activity_ranking" do
      let!(:monthly_activity_ranking) {create(:ranking, :monthly_activity_ranking)}
      let!(:daily_activity_ranking) {create(:ranking, :daily_activity_ranking)}
      let!(:hourly_activity_ranking) {create(:ranking, :hourly_activity_ranking)}

      it "「本日の活動ランキング」の一覧を返す" do
        aggregate_failures do
          expect(Ranking.daily_activity_ranking).to match_array([daily_activity_ranking])
        end
      end
    end

    context "#monthly_activity_ranking" do
      let!(:monthly_activity_ranking) {create(:ranking, :monthly_activity_ranking)}
      let!(:daily_activity_ranking) {create(:ranking, :daily_activity_ranking)}
      let!(:hourly_activity_ranking) {create(:ranking, :hourly_activity_ranking)}

      it "「今月の活動ランキング」の一覧を返す" do
        aggregate_failures do
          expect(Ranking.monthly_activity_ranking).to match_array([monthly_activity_ranking])
        end
      end
    end

    context "#in_session" do
      let!(:hourly_activity_ranking) {create(:ranking, :hourly_activity_ranking)}
      let!(:archived_ranking) {create(:ranking, :archived_hourly_activity_ranking)}

      it "現在開催中のランキング一覧を返す" do
        aggregate_failures do
          expect(Ranking.in_session).to match_array([hourly_activity_ranking])
        end
      end
    end
  end

  context "リレーションテスト" do
    context "dependent: :destroy" do
      let!(:ranking) {create(:ranking, :with_a_entry)}

      it "Rankingが削除されたら、それに紐づくRankingEntryも削除されること" do
        aggregate_failures do
          expect(RankingEntry.count).to eq 1
          ranking.destroy
          expect(RankingEntry.count).to eq 0
        end
      end
    end

    context "through" do
      let(:user) {create(:user)}
      let(:ranking) {create(:ranking)}
      let!(:ranking_entry) {create(:ranking_entry, ranking: ranking, user: user)}

      it "Rankingから直接User一覧を取得できる" do
        aggregate_failures do
          expect(ranking).to respond_to(:users)
          expect(ranking.users).to match_array([user])
        end
      end
    end
  end

  context "クラスメソッドテスト" do
    context "#self.create_monthly_activity_ranking(start_at=nil, end_at=nil)" do
      let(:start_at) {3.months.from_now.beginning_of_month}
      let(:end_at) {3.months.from_now.end_of_month}

      it "start_atとend_atの引数が指定されていない場合は、現在時刻の月の始まりがstart_atと、月の終わりがend_atにセットされた状態で「今月の活動ランキング」が作成される" do
        aggregate_failures do
          expect {
            Ranking.create_monthly_activity_ranking
          }.to change(Ranking.monthly_activity_ranking, :count).by(1)
          expect(Ranking.monthly_activity_ranking.first.start_at.to_s).to eq Time.zone.now.beginning_of_month.to_s
          expect(Ranking.monthly_activity_ranking.first.end_at.to_s).to eq Time.zone.now.end_of_month.to_s
        end
      end

      it "start_atとend_atの引数が指定されている場合、引数の通りのstart_atとend_atを持つ「今月の活動ランキング」が作成される" do
        aggregate_failures do
          expect {
            Ranking.create_monthly_activity_ranking(start_at, end_at)
          }.to change(Ranking.monthly_activity_ranking, :count).by(1)
          expect(Ranking.monthly_activity_ranking.first.start_at.to_s).to eq start_at.to_s
          expect(Ranking.monthly_activity_ranking.first.end_at.to_s).to eq end_at.to_s
        end
      end
    end

    context "#self.create_daily_activity_ranking(start_at=nil, end_at=nil)" do
      let(:start_at) {2.days.from_now.beginning_of_day}
      let(:end_at) {2.days.from_now.end_of_day}
    
      it "start_atとend_atの引数が指定されていない場合は、現在時刻の日の始まりがstart_atと、日の終わりがend_atにセットされた状態で「本日の活動ランキング」が作成される" do
        aggregate_failures do
          expect {
            Ranking.create_daily_activity_ranking
          }.to change(Ranking.daily_activity_ranking, :count).by(1)
          expect(Ranking.daily_activity_ranking.first.start_at.to_s).to eq Time.zone.now.beginning_of_day.to_s
          expect(Ranking.daily_activity_ranking.first.end_at.to_s).to eq Time.zone.now.end_of_day.to_s
        end
      end
      it "start_atとend_atの引数が指定されている場合、引数の通りのstart_atとend_atを持つ「本日の活動ランキング」が作成される" do
        aggregate_failures do
          expect {
            Ranking.create_daily_activity_ranking(start_at, end_at)
          }.to change(Ranking.daily_activity_ranking, :count).by(1)
          expect(Ranking.daily_activity_ranking.first.start_at.to_s).to eq start_at.to_s
          expect(Ranking.daily_activity_ranking.first.end_at.to_s).to eq end_at.to_s
        end
      end
    end

    context "#self.create_hourly_activity_ranking(start_at=nil, end_at=nil)" do
      let(:start_at) {3.hours.from_now.beginning_of_hour}
      let(:end_at) {3.hours.from_now.end_of_hour}

      it "start_atとend_atの引数が指定されていない場合は、現在時刻の時(Hour)の始まりがstart_atと、時(Hour)の終わりがend_atにセットされた状態で「毎時の活動ランキング」が作成される" do
        aggregate_failures do
          expect {
            Ranking.create_hourly_activity_ranking
          }.to change(Ranking.hourly_activity_ranking, :count).by(1)
          expect(Ranking.hourly_activity_ranking.first.start_at.to_s).to eq Time.zone.now.beginning_of_hour.to_s
          expect(Ranking.hourly_activity_ranking.first.end_at.to_s).to eq Time.zone.now.end_of_hour.to_s
        end
      end
      it "start_atとend_atの引数が指定されている場合、引数の通りのstart_atとend_atを持つ「毎時の活動ランキング」が作成される" do
        aggregate_failures do
          expect {
            Ranking.create_hourly_activity_ranking(start_at, end_at)
          }.to change(Ranking.hourly_activity_ranking, :count).by(1)
          expect(Ranking.hourly_activity_ranking.first.start_at.to_s).to eq start_at.to_s
          expect(Ranking.hourly_activity_ranking.first.end_at.to_s).to eq end_at.to_s
        end
      end
    end
  end

  context "インスタンスメソッドテスト" do
    context "#close" do
      let(:ranking) {build(:ranking, :hourly_activity_ranking)}

      it "closed_atに現在時刻がセットし、保存すること" do
        aggregate_failures do
          ranking.close
          ranking.reload
          expect(ranking.closed_at.to_s).to eq Time.zone.now.to_s
        end
      end
    end

    context "#entry(user)" do
      let(:user) {create(:user)}
      let(:ranking) {create(:ranking, :hourly_activity_ranking)}

      it "エントリーが完了すること(特定のRankingとUserに紐づくRankingEntryが作成されること）" do
        aggregate_failures do
          ranking.entry(user)
          expect {
            ranking.entry(user)
          }.to change(RankingEntry.where(user: user, ranking: ranking), :count).by(1)
        end
      end
    end

    context "#in_session?" do
      it "現在時刻が、Rankingのstart_atとend_atの時間内であればtrue、そうでなければfalseを返す" do
        aggregate_failures do
          expect(create(:ranking, :hourly_activity_ranking).in_session?).to be_truthy
          expect(create(:ranking, :archived_hourly_activity_ranking).in_session?).to be_falsy
        end
      end
    end

    context "#possible_to_entry?(user)" do
      let(:entry_user) {create(:user)}
      let(:non_entry_user) {create(:user)}
      let(:ranking_entry) {create(:ranking_entry, user: entry_user)}


      it "特定のRankingに対してUserがまだエントリーしていなければtrue, エントリーが済んでいる場合はfalseを返す" do
        aggregate_failures do
          expect(ranking_entry.ranking.possible_to_entry?(entry_user)).to be_falsy
          expect(ranking_entry.ranking.possible_to_entry?(non_entry_user)).to be_truthy
        end
      end
    end

    context "#top_three_rankers" do
      context "特定のRankingの参加者が３名以上の場合" do
        let(:ranking) {create(:ranking, :hourly_activity_ranking)}
        let!(:user_in_first_place) {create(:user, :with_single_instant_sex_activity)}
        let!(:user_in_second_place) {create(:user, :with_single_date_activity)}
        let!(:user_in_third_place) {create(:user, :with_single_get_phone_number_activity)}
        let!(:user_in_fourth_place) {create(:user, :with_single_talk_activity)}

        before do
          create(:ranking_entry, user: user_in_first_place, ranking: ranking)
          create(:ranking_entry, user: user_in_second_place, ranking: ranking)
          create(:ranking_entry, user: user_in_third_place, ranking: ranking)
          create(:ranking_entry, user: user_in_fourth_place, ranking: ranking)
        end

        it "上位３名のユーザーを取得" do
          aggregate_failures do
            expect(ranking.top_three_rankers).to eq [user_in_first_place, user_in_second_place, user_in_third_place]
          end
        end
      end

      context "特定のRankingの参加者が３名未満の場合" do
        let(:ranking) {create(:ranking, :hourly_activity_ranking)}
        let!(:user_in_first_place) {create(:user, :with_single_instant_sex_activity)}
        let!(:user_in_second_place) {create(:user, :with_single_date_activity)}

        before do
          create(:ranking_entry, user: user_in_first_place, ranking: ranking)
          create(:ranking_entry, user: user_in_second_place, ranking: ranking)
        end

        it "順位に基づき、参加者の数だけユーザーを取得" do
          aggregate_failures do
            expect(ranking.top_three_rankers).to eq [user_in_first_place, user_in_second_place]
          end
        end
      end
    end

    context "#user_ranking(consider_writing_activity=true)" do
      let(:ranking) {create(:ranking, :hourly_activity_ranking)}
      let!(:user_in_first_place) {create(:user, :with_single_instant_sex_activity)} # 100ポイント
      let!(:user_in_second_place) {create(:user, :with_single_date_activity)} # 20ポイント
      let!(:user_in_third_place) {create(:user, :with_single_get_phone_number_activity)} # 7ポイント
      # ３件のブログ記事を投稿しているため、その活動ポイントも含めると13ポイントそれを含めないで考えると3ポイントであることに注意
      # つまり、本来であれば3ポイントで4位になるはずだが、執筆活動の分までカウントすると2位になるということ
      let!(:user_in_fourth_place) {create(:user, :with_single_talk_activity, :with_blog_articles)}

      before do
        create(:ranking_entry, user: user_in_first_place, ranking: ranking)
        create(:ranking_entry, user: user_in_second_place, ranking: ranking)
        create(:ranking_entry, user: user_in_third_place, ranking: ranking)
        create(:ranking_entry, user: user_in_fourth_place, ranking: ranking)
      end

      context "consider_writing_activityがtrueの場合" do
        it "参加者のうち、特定の時間内により多くのポイントを獲得した順にユーザーをソートし、一覧を返す" do
          aggregate_failures do
            expect(ranking.user_ranking).to eq [user_in_first_place, user_in_second_place, user_in_fourth_place, user_in_third_place]
          end
        end
      end

      context "consider_writing_activityがfalseの場合" do
        it "参加者のうち、特定の時間内により多くのポイントを獲得（執筆活動（募集・ブログ）を除く）した順にユーザーをソートし、一覧を返す" do
          aggregate_failures do
            expect(ranking.user_ranking(false)).to eq [user_in_first_place, user_in_second_place, user_in_third_place, user_in_fourth_place]
          end
        end
      end
    end
  end
end
