require 'rails_helper'

RSpec.describe 'CreateRecruitment', type: :system do
  let(:user) { create(:user) }
  let(:title) { '新宿の歌舞伎町で本日18:00からナンパします！一緒に頑張りましょう！' }
  let(:description) { 'よろしくお願いします！' }
  let(:event_date) { 2.days.from_now }
  let(:prefecture) { '東京都' }

  it %(募集記事作成テスト - 正常系) do
    # 募集記事作成ページに遷移
    login_as(user, scope: :user)
    visit new_recruitment_path

    # デフォルトの開催日と都道府県がセットされている
    # 開催日に関しては、現在日がデフォルトでセットされている
    # 都道府県に関しては、ユーザーが活動範囲をセットしている場合はデフォルトでセットされている
    expect(page).to have_field "recruitment[event_date]", with: Date.today.strftime("%Y/%m/%d")
    expect(find("#recruitment_prefecture_code_select_box > .ui.dropdown > .text").text).to eq user.prefecture.name

    # フォームの入力
    sleep 0.1
    fill_in 'recruitment[title]', with: title
    fill_in 'recruitment[description]', with: description
    fill_in 'recruitment[event_date]', with: event_date.strftime('%Y/%m/%d')
    select_from_dropdown('#recruitment_prefecture_code_select_box > .dropdown', prefecture) # 都道府県を選択
    click_button '作成'

    # 作成されたデータの存在確認とプロパティ確認
    sleep 0.1
    recruitment = Recruitment.find_by_title title
    expect(recruitment.description).to eq description
    expect(recruitment.event_date.strftime('%Y/%m/%d')).to eq event_date.strftime('%Y/%m/%d')
    expect(recruitment.prefecture.name).to eq prefecture

    # 遷移先のページが正しいか確認
    expect(current_path).to eq recruitment_path(recruitment)
    # 遷移先のページに期待する値が表示されているか
    expect(page).to have_content '募集記事の作成が完了しました。'
    expect(page).to have_content recruitment.title
    expect(page).to have_content recruitment.description
    expect(page).to have_content %(#{recruitment.created_at.strftime('%Y年%m月%d日 %H時%M分')}に更新)
    expect(page).to have_content recruitment.event_date.strftime('%Y年%m月%d日')
    expect(page).to have_content recruitment.prefecture.name
    expect(page).to have_content 'メッセージ一覧'
    expect(page).to have_field 'message[message]'
  end

  it %(募集記事作成テスト - 異常系1: バリデーションに引っかかる) do
    # 募集作成ページに遷移
    login_as(user, scope: :user)
    visit new_recruitment_path

    # フォームを入力せずに作成ボタンをクリック
    sleep 0.1
    # 開催日と都道府県はデフォルトでセットされているので一旦空にする    # ※ 開催日に関してはデフォルトにする方法がわからないので放置
    click_button '作成'
    # 遷移先のページが正しいか確認
    expect(current_path).to eq new_recruitment_path

    # エラーメッセージが表示されていることを確認
    expect(page).to have_content '[タイトル] 入力必須です。'
    expect(page).to have_content '[募集内容] 入力必須です。'

    # Recruitmentが作成されていないことを確認
    expect(Recruitment.count).to eq 0
  end

  it %(募集記事作成テスト - 異常系2: 未ログインユーザーはログインページに島流し) do
    # 募集作成ページに遷移
    visit new_recruitment_path

    # ログイン画面にリダイレクトされていることを確認
    sleep 0.1
    expect(current_path).to eq new_user_session_path

    # エラーメッセージが表示されていることを確認
    expect(page).to have_content 'アカウント登録もしくはログインしてください。'
  end
end
