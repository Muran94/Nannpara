require 'rails_helper'

RSpec.describe 'DeleteRecruitment', type: :system do
  let(:user) {create(:user)}
  let(:other_user) {create(:user)}

  let(:recruitment) {create(:recruitment, user: user)}

  it %(オーナーによる募集記事削除テスト - 正常系) do
    # 募集記事編集ページに遷移
    login_as(user, :scope => :user)
    visit recruitment_path(recruitment)
    find("#recruitment-menu").click # 募集記事の設定メニューを開く
    find("#recruitment-delete-link").click # 削除リンクをクリック
    page.driver.browser.switch_to.alert.accept # confirmダイアログのOKボタンをクリック

    # 削除されたことを確認
    sleep 0.1
    expect(Recruitment.count).to eq 0

    # 更新データの確認
    sleep 0.1
    expect(current_path).to eq root_path

    # flashメッセージが表示されていることを確認
    expect(page).to have_content "募集記事の削除が完了しました。"
  end
end
