require "rails_helper"

RSpec.describe "CounterUsage", type: :system do
    let(:user) {create(:user)}

    context "ログインユーザー" do
        before do
            login_as user, scope: :user
            visit root_path
            find("#secondary-menu-counter-link").click # サブメニューバーのカウンターリンクをクリック
            sleep 0.1
        end

        context "カウントプラスボタン" do
            it "クリックしたカウンターのカウントが１増え、経験値とレベルが増えること" do
                expect(page).to have_content "カウンター"

                # 初期状態のチェック
                within ".user-level-display > span" do
                    expect(page).to have_content "1" # 初期状態のレベルは1
                end
                within ".user-experience-point-display > span" do
                    expect(page).to have_content "0" # 初期状態の経験値は0
                end
                within "#talk-counter-display > span" do
                    expect(page).to have_content "0" # 「声かけ」のカウントが初期状態（0）である
                end

                # 各カウンターのカウントダウンボタンが無効化されていること（カウントが０の時は無効化されるようになっている）
                expect(find("#talk-count-decrement-button")['class']).to match /disabled/
                expect(find("#get-phone-number-count-decrement-button")['class']).to match /disabled/
                expect(find("#date-count-decrement-button")['class']).to match /disabled/
                expect(find("#sex-on-second-date-count-decrement-button")['class']).to match /disabled/
                expect(find("#sex-on-first-date-count-decrement-button")['class']).to match /disabled/
                expect(find("#instant-sex-count-decrement-button")['class']).to match /disabled/

                # 声かけのカウントアップ
                find("#talk-count-increment-button").click # 「声かけ」のカウントアップボタンをクリック
                sleep 0.1
                within ".user-level-display > span" do
                    expect(page).to have_content "2" # レベルが2に上がっている
                end
                within ".user-experience-point-display > span" do
                    expect(page).to have_content "3" # 経験値を3取得し、合計3になっている
                end
                within "#talk-counter-display > span" do
                    expect(page).to have_content "1" # カウントが1増えている
                end

                # 番ゲのカウントアップ
                find("#get-phone-number-count-increment-button").click # 「番ゲ」のカウントアップボタンをクリック
                sleep 0.1
                within ".user-level-display > span" do
                    expect(page).to have_content "3" # レベルが3に上がっている
                end
                within ".user-experience-point-display > span" do
                    expect(page).to have_content "10" # 経験値を7取得し、合計10になっている
                end
                within "#get-phone-number-counter-display > span" do
                    expect(page).to have_content "1" # カウントが1増えている
                end

                # 連れ出しのカウントアップ
                find("#date-count-increment-button").click # 「連れ出し」のカウントアップボタンをクリック
                sleep 0.1
                within ".user-level-display > span" do
                    expect(page).to have_content "5" # レベルが5に上がっている
                end
                within ".user-experience-point-display > span" do
                    expect(page).to have_content "30" # 経験値を20取得し、合計30になっている
                end
                within "#date-counter-display > span" do
                    expect(page).to have_content "1" # カウントが1増えている
                end

                # 準々即のカウントアップ
                find("#sex-on-second-date-count-increment-button").click # 「準々即」のカウントアップボタンをクリック
                sleep 0.1
                within ".user-level-display > span" do
                    expect(page).to have_content "7" # レベルが8に上がっている
                end
                within ".user-experience-point-display > span" do
                    expect(page).to have_content "80" # 経験値を50取得し、合計80になっている
                end
                within "#sex-on-second-date-counter-display > span" do
                    expect(page).to have_content "1" # カウントが1増えている
                end

                # 準即のカウントアップ
                find("#sex-on-first-date-count-increment-button").click # 「準即」のカウントアップボタンをクリック
                sleep 0.1
                within ".user-level-display > span" do
                    expect(page).to have_content "10" # レベルが12に上がっている
                end
                within ".user-experience-point-display > span" do
                    expect(page).to have_content "155" # 経験値を75取得し、合計155になっている
                end
                within "#sex-on-first-date-counter-display > span" do
                    expect(page).to have_content "1" # カウントが1増えている
                end

                # 即のカウントアップ
                find("#instant-sex-count-increment-button").click # 「即」のカウントアップボタンをクリック
                sleep 0.1
                within ".user-level-display > span" do
                    expect(page).to have_content "13" # レベルが16に上がっている
                end
                within ".user-experience-point-display > span" do
                    expect(page).to have_content "255" # 経験値を100取得し、合計255になっている
                end
                within "#instant-sex-counter-display > span" do
                    expect(page).to have_content "1" # カウントが1増えている
                end
            end
        end

        context "カウントマイナスボタン" do
            let(:user) do
                user = create(:user)
                create(:activity, user: user, activity_type: ActivityType.find_by_name_ja("声かけ"))
                create(:activity, user: user, activity_type: ActivityType.find_by_name_ja("番ゲ"))
                create(:activity, user: user, activity_type: ActivityType.find_by_name_ja("連れ出し"))
                create(:activity, user: user, activity_type: ActivityType.find_by_name_ja("即"))
                create(:activity, user: user, activity_type: ActivityType.find_by_name_ja("準即"))
                create(:activity, user: user, activity_type: ActivityType.find_by_name_ja("準々即"))
                user
            end

            it "クリックしたカウンターのカウントが１減り、経験値とレベルが減ること" do
                # 初期状態のチェック（全てのカウンターでカウントが１になっており、それにふさわしいレベルと経験値である）
                within ".user-level-display > span" do
                    expect(page).to have_content "13" # 初期状態のレベルは13
                end
                within ".user-experience-point-display > span" do
                    expect(page).to have_content "255" # 初期状態の経験値は255
                end
                within "#talk-counter-display > span" do
                    expect(page).to have_content "1" # 「声かけ」のカウントが初期状態（1）である
                end
                within "#get-phone-number-counter-display > span" do
                    expect(page).to have_content "1" # 「番ゲ」のカウントが初期状態（1）である
                end
                within "#date-counter-display > span" do
                    expect(page).to have_content "1" # 「連れ出し」のカウントが初期状態（1）である
                end
                within "#sex-on-second-date-counter-display > span" do
                    expect(page).to have_content "1" # 「準々即」のカウントが初期状態（1）である
                end
                within "#sex-on-first-date-counter-display > span" do
                    expect(page).to have_content "1" # 「準即」のカウントが初期状態（1）である
                end
                within "#instant-sex-counter-display > span" do
                    expect(page).to have_content "1" # 「即」のカウントが初期状態（1）である
                end

                # 声かけのカウントダウン
                find("#talk-count-decrement-button").click # 「声かけ」のカウントダウンボタンをクリック
                sleep 0.1
                within ".user-level-display > span" do
                    expect(page).to have_content "13" # レベル13のまま
                end
                within ".user-experience-point-display > span" do
                    expect(page).to have_content "252" # 経験値が3ポイント減り、合計252になっている
                end
                within "#talk-counter-display > span" do
                    expect(page).to have_content "0" # カウントが0に減っている
                end
                expect(find("#talk-count-decrement-button")['class']).to match /disabled/ # カウントダウンボタンが無効化されている

                # 番ゲのカウントダウン
                find("#get-phone-number-count-decrement-button").click # 「番ゲ」のカウントダウンボタンをクリック
                sleep 0.1
                within ".user-level-display > span" do
                    expect(page).to have_content "13" # レベル13のまま
                end
                within ".user-experience-point-display > span" do
                    expect(page).to have_content "245" # 経験値が7ポイント減り、合計245になっている
                end
                within "#get-phone-number-counter-display > span" do
                    expect(page).to have_content "0" # カウントが0に減っている
                end
                expect(find("#get-phone-number-count-decrement-button")['class']).to match /disabled/ # カウントダウンボタンが無効化されている

                # 連れ出しのカウントダウン
                find("#date-count-decrement-button").click # 「連れ出し」のカウントダウンボタンをクリック
                sleep 0.1
                within ".user-level-display > span" do
                    expect(page).to have_content "12" # レベルが12に下がっている
                end
                within ".user-experience-point-display > span" do
                    expect(page).to have_content "225" # 経験値が20ポイント減り、合計225になっている
                end
                within "#date-counter-display > span" do
                    expect(page).to have_content "0" # カウントが0に減っている
                end
                expect(find("#date-count-decrement-button")['class']).to match /disabled/ # カウントダウンボタンが無効化されている

                # 準々即のカウントダウン
                find("#sex-on-second-date-count-decrement-button").click # 「準々即」のカウントダウンボタンをクリック
                sleep 0.1
                within ".user-level-display > span" do
                    expect(page).to have_content "11" # レベルが11に下がっている
                end
                within ".user-experience-point-display > span" do
                    expect(page).to have_content "175" # 経験値を50ポイント減り、合計175になっている
                end
                within "#sex-on-second-date-counter-display > span" do
                    expect(page).to have_content "0" # カウントが0に減っている
                end
                expect(find("#sex-on-second-date-count-decrement-button")['class']).to match /disabled/ # カウントダウンボタンが無効化されている

                # 準即のカウントダウン
                find("#sex-on-first-date-count-decrement-button").click # 「準即」のカウントダウンボタンをクリック
                sleep 0.1
                within ".user-level-display > span" do
                    expect(page).to have_content "8" # レベルが8に下がっている
                end
                within ".user-experience-point-display > span" do
                    expect(page).to have_content "100" # 経験値を75ポイント減り、合計100になっている
                end
                within "#sex-on-first-date-counter-display > span" do
                    expect(page).to have_content "0" # カウントが0に減っている
                end
                expect(find("#sex-on-first-date-count-decrement-button")['class']).to match /disabled/ # カウントダウンボタンが無効化されている

                # 即のカウントダウン
                find("#instant-sex-count-decrement-button").click # 「即」のカウントダウンボタンをクリック
                sleep 0.1
                within ".user-level-display > span" do
                    expect(page).to have_content "1" # レベルが1に下がっている
                end
                within ".user-experience-point-display > span" do
                    expect(page).to have_content "0" # 経験値を100ポイント減り、合計0になっている
                end
                within "#instant-sex-counter-display > span" do
                    expect(page).to have_content "0" # カウントが0に減っている
                end
                expect(find("#instant-sex-count-decrement-button")['class']).to match /disabled/ # カウントダウンボタンが無効化されている
            end
        end
    end

    context "未ログインユーザー" do
        it "カウンターページにアクセスしようとするとログインページにリダイレクトされること" do
            visit root_path
            find("#secondary-menu-counter-link").click # サブメニューバーのカウンターリンクをクリック
            sleep 0.1

            # ログイン画面にリダイレクトされていることを確認
            expect(page).to have_content 'アカウント登録もしくはログインしてください。'
        end
    end
end