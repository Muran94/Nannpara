require "rails_helper"

RSpec.describe "ShowRankingPage", type: :system do
    let(:user) {create(:user)}
    before {login_as user, scope: :user}

    context "参加者がいない場合" do
        let(:hourly_activity_ranking_without_entries) {create(:ranking, :hourly_activity_ranking)}

        it "「まだ参加者がいません。」と表示されること" do
            visit ranking_path hourly_activity_ranking_without_entries
            expect(page).to have_content "まだ参加者がいません。"
        end
    end

    context "参加者がいる場合" do
        let(:hourly_activity_ranking_with_entries) {create(:ranking, :hourly_activity_ranking, :with_five_entries)}

        it "参加者がリストアップされていること" do
            visit ranking_path hourly_activity_ranking_with_entries
            hourly_activity_ranking_with_entries.users.each do |user|
                expect(page).to have_content user.name
            end
        end
    end
end