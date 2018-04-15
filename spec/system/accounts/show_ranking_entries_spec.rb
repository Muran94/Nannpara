require "rails_helper"

RSpec.describe "ShowRankingEntries", type: :system do
    let(:user) {create(:user)}
    before {login_as user, scope: :user}

    context "エントリー済みのランキングが存在する場合" do
        # 開催中のランキングが３件、開催終了しているランキングが１件
        let(:user) {create(:user, :with_three_ranking_entries)}
        let(:archived_ranking) {create(:ranking, :archived_hourly_activity_ranking).extend(RankingDecorator)}
        let!(:ranking_entry) {create(:ranking_entry, ranking: archived_ranking, user: user)}

        it "現在開催中のものと開催終了しているものの両方が存在している場合、色が違うこと、タイトルの表記がちがうこと" do
            # プロフィールページからエントリー済みのランキングページに遷移
            visit profile_account_path user
            sleep 0.1
            within '#account-tab' do
                click_link "ランキング"
                sleep 0.1
            end

            user.rankings.each do |ranking|
                ranking.extend(RankingDecorator)
                expect(page).to have_content ranking.name
            end
            expect(all(".in-session").count).to eq 3 # 開催中であることを表すのHTMLclass属性が３つ存在する
            expect(page).to have_content archived_ranking.name
        end
    end

    context "エントリー済みのランキングが存在しない場合" do
        let(:user) {create(:user)}

        it "「エントリー済のランキングがありません。」と表示されること" do
            # 直接エントリー済みのランキングページに遷移
            visit rankings_account_path user

            expect(page).to have_content "エントリー済のランキングがありません。"
        end
    end
end