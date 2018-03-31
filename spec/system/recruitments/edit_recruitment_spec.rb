require 'rails_helper'

RSpec.describe 'EditRecruitment', type: :system do
  let(:user) {create(:user)}
  let(:other_user) {create(:user)}

  let(:title) {"募集記事編集テスト"}
  let(:description) {"これから募集記事の編集をテストしたいと思います。"}
  let(:event_date) {5.days.from_now}
  let(:prefecture_code) {13} # 東京
  let(:venue) {"新宿歌舞伎町"}

  let(:new_title) {"（更新済み）募集記事編集テスト"}

  let(:recruitment) do
    create(
      :recruitment,
      title: title,
      description: description,
      event_date: 5.days.from_now,
      prefecture_code: prefecture_code,
      venue: venue,
      user: user
    )
  end

  it %(オーナーによる募集記事編集テスト - 正常系) do
    # 募集記事編集ページに遷移
    login_as(user, :scope => :user)
    visit recruitment_path(recruitment)
    find("#recruitment-menu").click # 募集記事の設定メニューを開く
    find("#recruitment-edit-link").click # 編集リンクをクリック

    # フォーム検証
    sleep 0.1
    expect(page).to have_field "recruitment[title]", with: title
    expect(page).to have_field "recruitment[description]", with: description
    expect(page).to have_field "recruitment[event_date]", with: event_date.strftime("%Y/%m/%d %H:%M")
    expect(find("#recruitment_prefecture_code_select_box > .dropdown > .text")).to have_content JpPrefecture::Prefecture.find(13).name
    expect(page).to have_field "recruitment[venue]", with: venue

    # フォーム書き換え
    fill_in "recruitment[title]", with: new_title # タイトル書き換え
    click_button "更新"

    # 更新データの確認
    sleep 0.1
    recruitment.reload
    expect(recruitment.title).to eq new_title

    # 遷移先のページに期待する値が表示されているか
    expect(page).to have_content "募集記事の更新が完了しました。"
    expect(page).to have_content new_title
    expect(page).to have_content recruitment.description
    expect(page).to have_content %(#{recruitment.created_at.strftime('%Y年%m月%d日 %H時%M分')}に更新)
    expect(page).to have_content recruitment.event_date.strftime('%Y年%m月%d日 %H時%M分')
    expect(page).to have_content recruitment.prefecture.name
    expect(page).to have_content recruitment.venue
    expect(page).to have_content "メッセージ一覧"
    expect(page).to have_field "message[message]"
  end

  it %(オーナーによる募集記事編集テスト - 異常系1: バリデーションに引っかかる) do
    # 募集記事編集ページに遷移
    login_as(user, :scope => :user)
    visit recruitment_path(recruitment)
    find("#recruitment-menu").click # 募集記事の設定メニューを開く
    find("#recruitment-edit-link").click # 編集リンクをクリック

    # フォーム検証
    sleep 0.1
    expect(page).to have_field "recruitment[title]", with: title
    expect(page).to have_field "recruitment[description]", with: description
    expect(page).to have_field "recruitment[event_date]", with: event_date.strftime("%Y/%m/%d %H:%M")
    expect(find("#recruitment_prefecture_code_select_box > .dropdown > .text")).to have_content JpPrefecture::Prefecture.find(13).name
    expect(page).to have_field "recruitment[venue]", with: venue

    # フォーム書き換え
    fill_in "recruitment[title]", with: ""
    click_button "更新"

    # ページ遷移していないことを家訓
    expect(current_path).to eq edit_recruitment_path(recruitment)

    # エラーメッセージが表示されていることを確認
    expect(page).to have_content "[タイトル] 入力必須です。"
  end

  it %(未ログインユーザーによる募集記事編集テスト - 異常系2: ログイン要求) do
    # URL直だたきで編集ページに遷移
    visit edit_recruitment_path(recruitment)

    # ログイン画面にリダイレクトされていることを確認
    sleep 0.1
    expect(current_path).to eq new_user_session_path

    # エラーメッセージが表示されていることを確認
    expect(page).to have_content "アカウント登録もしくはログインしてください。"
  end

  it %(オーナー以外のユーザーによる募集記事編集テスト - 異常系3: 不正検知) do
    # URL直だたきで編集ページに遷移
    login_as(other_user, :scope => :user)
    visit edit_recruitment_path(recruitment)

    # ログイン画面にリダイレクトされていることを確認
    sleep 0.1
    expect(current_path).to eq root_path

    # エラーメッセージが表示されていることを確認
    expect(page).to have_content "不正な操作です。もう一度最初からやり直してください。"
  end
end
