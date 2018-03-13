require 'rails_helper'

describe MessageDecorator do
  let(:message) { Message.new.extend MessageDecorator }
  subject { message }
  it { should be_a Message }

  describe "#format_user_name" do
    context "userを持つ場合（ログインユーザーによる投稿）" do
      let(:user) {build(:user)}
      let(:message) {build(:message, user: user).extend MessageDecorator}

      it "ユーザー名を返す" do
        expect(message.format_user_name).to eq message.user.name
      end
    end

    context "userを持たない場合（未ログインユーザーによる投稿）" do
      let(:message) {build(:message).extend MessageDecorator}

      it "「南原さん」を返す" do
        expect(message.format_user_name).to eq "南原さん"
      end
    end
  end
end
