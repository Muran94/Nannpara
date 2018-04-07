require 'rails_helper'

RSpec.describe 'Index', type: :system do
  context 'ブログ記事が存在する場合' do
    let(:title) { '初めてのナンパ' }

    before do
      create(:blog_article, title: title)
    end

    it 'ブログ記事が存在する場合は、ブログ記事のリストが表示される' do
      # ブログ記事一覧ページに遷移
      visit blog_articles_path

      expect(page).not_to have_content 'まだブログ記事がありません。'
      expect(page).to have_content title
    end
  end

  context 'ブログ記事が存在しない場合' do
    it 'ブログ記事が存在しない場合は、「まだブログ記事がありません」と表示される' do
      # ブログ記事一覧ページに遷移
      visit blog_articles_path

      expect(page).to have_content 'まだブログ記事がありません。'
    end
  end
end
