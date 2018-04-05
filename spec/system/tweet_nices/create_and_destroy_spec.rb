require "rails_helper"

RSpec.describe "CreateAndDestroy", type: :system do
  let(:user) {create(:user)}
  let(:other_user) {create(:user)}
  let!(:tweet) {create(:tweet)}

  context "「いいね」の登録と解除テスト" do
    before do
      login_as user, scope: :user
      visit tweets_path
    end

    it "登録したらthumbs upアイコンがオレンジ色に代わり、「いいね」カウントが１増える。解除したら灰色になり、カウントが１減る" do
      expect(all(".thumbs.up.orange").count).to eq 0 # 「いいね」ボタンがオレンジ色でない
      expect(find(".nice-count").text.to_i).to eq 0 # 「いいね」ボタンの横のいいね数が0になっている

      find(".js-tweet-nice-button").click # 「いいね」ボタンをクリック（登録）
      wait_for_ajax

      expect(all(".thumbs.up.orange").count).to eq 1 # 「いいね」ボタンがオレンジ色
      expect(find(".nice-count").text.to_i).to eq 1 # 「いいね」ボタンの横のいいね数が1に増えている

      find(".js-tweet-nice-button").click # 「いいね」ボタンをもう一度クリック（解除）
      wait_for_ajax

      expect(all(".thumbs.up.orange").count).to eq 0 # 「いいね」ボタンがオレンジ色でない
      expect(find(".nice-count").text.to_i).to eq 0 # 「いいね」ボタンの横のいいね数が0に減っている
    end
  end

  context "特定のつぶやきに対して、既に自分が「いいね」をしている場合の解除テスト" do
    before do
      create(:tweet_nice, user: user, tweet: tweet)
      login_as user, scope: :user
      visit tweets_path
    end

    it "オレンジ色のthumbs upアイコンが表示されており、「いいね」カウントが１になっている。クリックすると「いいね」が解除され、灰色になり、カウントが0になる" do
      expect(all(".thumbs.up.orange").count).to eq 1 # 「いいね」ボタンがオレンジ色
      expect(find(".nice-count").text.to_i).to eq 1 # 「いいね」ボタンの横のいいね数が1になっている

      find(".js-tweet-nice-button").click # 「いいね」ボタンをクリック（登録）
      wait_for_ajax

      expect(all(".thumbs.up.orange").count).to eq 0 # 「いいね」ボタンがオレンジ色でなくなる
      expect(find(".nice-count").text.to_i).to eq 0 # 「いいね」ボタンの横のいいね数が0に減っている
    end
  end

  context "特定のつぶやきに対して、既に他の誰かが「いいね」をしている場合の登録テスト" do
    before do
      create(:tweet_nice, user: other_user, tweet: tweet)
      login_as user, scope: :user
      visit tweets_path
    end

    it "灰色のthumbs upアイコンが表示されており、「いいね」カウントが１になっている。クリックすると「いいね」の登録が完了し、アイコンがオレンジ色に代わり、カウントが1になる" do
      expect(all(".nice-count").count).to eq 1 # 「いいね」ボタンが表示されている
      expect(all(".thumbs.up.orange").count).to eq 0 # 「いいね」ボタンがオレンジ色でない
      expect(find(".nice-count").text.to_i).to eq 1 # 「いいね」ボタンの横のいいね数が1になっている

      find(".js-tweet-nice-button").click # 「いいね」ボタンをクリック（登録）
      wait_for_ajax

      expect(all(".thumbs.up.orange").count).to eq 1 # 「いいね」ボタンがオレンジ色に変わる
      expect(find(".nice-count").text.to_i).to eq 2 # 「いいね」ボタンの横のいいね数が2に増える
    end
  end

  context "未ログイン時" do
    before {visit tweets_path}

    it "「いいね」ボタンが表示されていない" do
      expect(all(".js-tweet-nice-button").count).to eq 0
    end
  end
end
