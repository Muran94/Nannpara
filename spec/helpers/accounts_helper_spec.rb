require 'rails_helper'

RSpec.describe AccountsHelper, type: :helper do
  describe %(#account_owner?(user)) do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    context %(ユーザーログイン済み) do
      before do
        allow(helper).to receive(:user_signed_in?).and_return(true)
        allow(helper).to receive(:current_user).and_return(user)
      end

      it %(アカウントオーナーである場合は true を返し、オーナーでない場合は false を返す) do
        aggregate_failures do
          expect(helper.account_owner?(user)).to eq true
          expect(helper.account_owner?(other_user)).to eq false
        end
      end
    end

    context %(ユーザー未ログイン) do
      before { allow(helper).to receive(:user_signed_in?).and_return(false) }

      it %(false を返す) do
        expect(helper.account_owner?(user)).to eq false
      end
    end
  end

  describe %(#activate_tab_if_correct_page(action_name)) do
    before { allow(helper.controller).to receive(:action_name).and_return('profile') }

    it %(タブが表すページが現在ページと同じであれば "active" を返し、そうでなければ nil を返す) do
      aggregate_failures do
        expect(helper.activate_tab_if_correct_page('profile')).to eq 'active'
        expect(helper.activate_tab_if_correct_page('recruitments')).to eq nil
      end
    end
  end
end
