require "rails_helper"

RSpec.describe "ShowRankingIndex", type: :system do
    let(:user) {create(:user)}
    before {login_as(user, scope: :user)}

    context "開催中のランキングが存在しない場合" do
        it "「毎時」「本日」「今月」のランキング全てに「現在開催しておりません。」と表示される" do
            visit rankings_path
            sleep 0.1

            within "#hourly-activity-ranking-segment" do
                expect(page).to have_content "現在開催しておりません。"
            end
            within "#daily-activity-ranking-segment" do
                expect(page).to have_content "現在開催しておりません。"
            end
            within "#monthly-activity-ranking-segment" do
                expect(page).to have_content "現在開催しておりません。"
            end
        end
    end

    context "開催中のランキングが存在する場合" do
        let!(:hourly_activity_ranking) {create(:ranking, :hourly_activity_ranking).extend(RankingDecorator)}
        let!(:daily_activity_ranking) {create(:ranking, :daily_activity_ranking).extend(RankingDecorator)}
        let!(:monthly_activity_ranking) {create(:ranking, :monthly_activity_ranking).extend(RankingDecorator)}

        context "参加者がいない" do
            it "ランキング名とともに、「まだ参加者がいません」と表示される" do
                visit rankings_path
                sleep 0.1

                within "#hourly-activity-ranking-segment" do
                    expect(page).to have_content hourly_activity_ranking.name
                    expect(page).to have_content "まだ参加者がいません。"
                end
                within "#daily-activity-ranking-segment" do
                    expect(page).to have_content daily_activity_ranking.name
                    expect(page).to have_content "まだ参加者がいません。"
                end
                within "#monthly-activity-ranking-segment" do
                    expect(page).to have_content monthly_activity_ranking.name
                    expect(page).to have_content "まだ参加者がいません。"
                end
            end
        end

        context "参加者が既に１名おり、カウントによって参加した場合" do
            let!(:entry_user) {create(:user, :with_three_talk_activities)}

            it "参加者が、正しい順位正しい名前正しいポイントで参加しており、カウントによって参加が完了した後、カウントしたユーザーが表示されていること" do
                visit rankings_path
                sleep 0.1

                # 既に参加者がいる
                within "#hourly-activity-ranking-segment" do
                    expect(page).to have_content "1位"
                    expect(page).to have_content entry_user.name
                    expect(page).to have_content "9p"
                end
                within "#daily-activity-ranking-segment" do
                    expect(page).to have_content "1位"
                    expect(page).to have_content entry_user.name
                    expect(page).to have_content "9p"
                end
                within "#monthly-activity-ranking-segment" do
                    expect(page).to have_content "1位"
                    expect(page).to have_content entry_user.name
                    expect(page).to have_content "9p"
                end

                # 二人目の参加者はまだいない
                expect(page).not_to have_css ".rank-2"

                visit activities_path
                sleep 0.1
                # 「声かけ」カウント
                find("#talk-count-increment-button").click
                sleep 0.1

                # ランキングページに戻る
                visit rankings_path
                sleep 0.1

                # 参加が完了し、2位に君臨している
                within "#hourly-activity-ranking-segment" do
                    expect(page).to have_content "2位"
                    expect(page).to have_content user.name
                    expect(page).to have_content "3p"
                end
                within "#daily-activity-ranking-segment" do
                    expect(page).to have_content "2位"
                    expect(page).to have_content user.name
                    expect(page).to have_content "3p"
                end
                within "#monthly-activity-ranking-segment" do
                    expect(page).to have_content "2位"
                    expect(page).to have_content user.name
                    expect(page).to have_content "3p"
                end
            end
        end
    end
end
