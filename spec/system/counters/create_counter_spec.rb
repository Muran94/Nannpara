require "rails_helper"

RSpec.describe "CreateCounter", type: :system do
  let(:user) {create(:user)}

  context "ログインユーザー" do
    it "それぞれのカウンターのボタンをクリックできることと、期間の絞り込みが可能である" do
      # ログイン後、カウンターページに移動
      login_as user, scope: :user
      visit new_counter_path
      sleep 1

      # ヘッダーの存在チェック
      expect(page).to have_content "声かけ"
      expect(page).to have_content "バンゲ"
      expect(page).to have_content "即"

      # クリックテスト
      find("#speak-counter-button").click # 「声かけ」のカウンターボタンをクリック
      sleep 1
      within "#speak-counter-display" do
        expect(page).to have_content "1"
      end
      find("#tel-counter-button").click # 「バンゲ」のカウンターボタンをクリック
      sleep 1
      within "#tel-counter-display" do
        expect(page).to have_content "1"
      end
      find("#sex-counter-button").click # 「即」のカウンターボタンをクリック
      sleep 1
      within "#sex-counter-display" do
        expect(page).to have_content "1"
      end

      # 表示数検証のためデータを作成
      create(:counter, counter_type: "声かけ", user: user, created_at: 3.days.ago)
      create(:counter, counter_type: "声かけ", user: user, created_at: 10.days.ago)

      # 期間絞り込みテスト
      find("#day-period-button").click # 「１日」をクリック
      sleep 1
      within "#speak-counter-display" do
        expect(page).to have_content "1"
      end
      find("#week-period-button").click # 「１日」をクリック
      sleep 1
      within "#speak-counter-display" do
        expect(page).to have_content "2"
      end
      find("#month-period-button").click # 「１日」をクリック
      sleep 1
      within "#speak-counter-display" do
        expect(page).to have_content "3"
      end
    end
  end

  context "未ログインユーザー" do
    it "ログインページに強制リダイレクトされること" do
      visit new_counter_path
      sleep 1

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content "アカウント登録もしくはログインしてください。"
    end
  end
end
