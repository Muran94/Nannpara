require 'rails_helper'

RSpec.describe 'ShowInquiry', type: :system do
  it '問い合わせページが正常に表示され、問い合わせ先のメールアドレスが確認できること' do
    visit service_inquiry_path

    expect(page).to have_content '問い合わせ'
    expect(page).to have_link Settings.service.owners_email_address
  end
end
