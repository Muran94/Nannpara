require "rails_helper"

RSpec.describe "ShowIndex", type: :system do
    let(:user) {create(:user)}

    context "アカウントのレベル・経験値表示" do
        context "ログイン済み" do
            before {login_as user, scope: :user}

            it "ログイン済みのユーザーの画面には、レベルや経験値が表示される" do
                visit root_path
                expect(page).to have_css ".user-level-display"
                within ".user-level-display" do
                    expect(page).to have_content "レベル"
                    expect(page).to have_content "ナンパ素人"
                end
            end
        end

        context "未ログイン" do
            it "未ログインユーザーの画面には、レベルや経験値が表示されない" do
                visit root_path
                expect(page).not_to have_css ".user-level-display"
                expect(page).not_to have_content "レベル"
                expect(page).not_to have_content "ナンパ素人"
            end
        end
    end

    context "募集記事リスト" do
        context "募集記事が存在する場合" do
            let(:first_recruitment_title) {"今日中にレベル１０上げたいです！一緒に頑張りましょう！"}
            let(:second_recruitment_title) {"新宿でストナン"}
            let(:third_recruitment_title) {"本日の１９時から渋谷でストナン"}
            let(:fourth_recruitment_title) {"地蔵せずに一緒に攻めていきましょう！"}
            let(:unshowed_recruitment_title) {"この投稿は表示されておりません。"}
            let!(:first_recruitment) {create(:recruitment, title: first_recruitment_title, event_date: 1.day.from_now.to_date, closed_at: nil)}
            let!(:second_recruitment) {create(:recruitment, title: second_recruitment_title, event_date: 2.day.from_now.to_date, closed_at: nil)}
            let!(:third_recruitment) {create(:recruitment, title: third_recruitment_title, event_date: 3.day.from_now.to_date, closed_at: nil)}
            let!(:fourth_recruitment) {create(:recruitment, title: fourth_recruitment_title, event_date: 4.day.from_now.to_date, closed_at: nil)}
            let!(:unshowed_recruitment) {create(:recruitment, title: unshowed_recruitment_title, event_date: 4.day.from_now.to_date, closed_at:Time.zone.now)}

            it "募集記事が３件表示される" do
                visit root_path
                within ".recruitment-lists-segment" do
                    expect(page).to have_content first_recruitment_title
                    expect(page).to have_content second_recruitment_title
                    expect(page).to have_content third_recruitment_title
                    expect(page).not_to have_content fourth_recruitment_title
                    expect(page).not_to have_content unshowed_recruitment_title
                end
            end
        end

        context "募集記事が存在しない場合" do
            it "「まだ募集記事がありません。」と表示される" do
                visit root_path
                within ".recruitment-lists-segment" do
                    expect(page).to have_content "まだ募集記事がありません。"
                end
            end
        end
    end

    context "ブログ記事" do
        context "ブログ記事が存在する場合" do
            let(:first_blog_article_title) {"ナンパやめます。さようなら"}
            let(:second_blog_article_title) {"ナンパで心が折れた男の話"}
            let(:third_blog_article_title) {"声かけに使えるフレーズ集"}
            let(:fourth_blog_article_title) {"ナンパ初心者にありがちなことと対処法"}
            let!(:first_blog_article) {create(:blog_article, title: first_blog_article_title, created_at: 1.day.ago)}
            let!(:second_blog_article) {create(:blog_article, title: second_blog_article_title, created_at: 2.day.ago)}
            let!(:third_blog_article) {create(:blog_article, title: third_blog_article_title, created_at: 3.day.ago)}
            let!(:fourth_blog_article) {create(:blog_article, title: fourth_blog_article_title, created_at: 4.day.ago)}

            it "募集記事が３件表示される" do
                visit root_path
                within ".blog_article-lists-segment" do
                    expect(page).to have_content first_blog_article_title
                    expect(page).to have_content second_blog_article_title
                    expect(page).to have_content third_blog_article_title
                    expect(page).not_to have_content fourth_blog_article_title
                end
            end
        end

        context "募集記事が存在しない場合" do
            it "「まだ募集記事がありません。」と表示される" do
                visit root_path
                within ".blog_article-lists-segment" do
                    expect(page).to have_content "まだブログ記事がありません。"
                end
            end
        end
    end
end