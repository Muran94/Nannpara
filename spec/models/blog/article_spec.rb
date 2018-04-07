# == Schema Information
#
# Table name: blog_articles
#
#  id         :integer          not null, primary key
#  title      :string
#  content    :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Blog::Article, type: :model do
  context 'バリデーションテスト' do
    context 'title' do
      context 'presence' do
        it 'titleが nil か 空の場合バリデーションに引っかかり、そうでない場合はバリデーションに引っかからない' do
          aggregate_failures do
            expect(build_stubbed(:blog_article, title: nil).valid?).to be_falsy
            expect(build_stubbed(:blog_article, title: '').valid?).to be_falsy
            expect(build_stubbed(:blog_article, title: 'ナンパの極意 初級編').valid?).to be_truthy
          end
        end
      end

      context 'uniqueness' do
        let(:title) { 'ナンパについて初心者に伝えたいこと' }

        it '既に同じタイトルのブログ記事が存在する場合はバリデーションに引っかかり、そうでない場合はひっかからない' do
          aggregate_failures do
            # 同じタイトルのブログ記事が存在していない状態
            blog_article = build(:blog_article, title: title)
            expect(blog_article.valid?).to be_truthy
            blog_article.save

            # 既に存在するタイトルである場合にはバリデーションに引っかかる
            expect(build(:blog_article, title: title).valid?).to be_falsy
          end
        end
      end

      context 'length' do
        it "#{Blog::Article::MAXIMUM_TITLE_LENGTH}文字以下ならバリデーションに引っかからず、超えていたらバリデーションに引っかかる" do
          aggregate_failures do
            expect(build_stubbed(:blog_article, title: 'a' * (Blog::Article::MAXIMUM_TITLE_LENGTH - 1)).valid?).to be_truthy
            expect(build_stubbed(:blog_article, title: 'a' * Blog::Article::MAXIMUM_TITLE_LENGTH).valid?).to be_truthy
            expect(build_stubbed(:blog_article, title: 'a' * (Blog::Article::MAXIMUM_TITLE_LENGTH + 1)).valid?).to be_falsy
          end
        end
      end
    end

    context 'content' do
      context 'presence' do
        it 'contentが nil か 空の場合バリデーションに引っかかり、そうでない場合はバリデーションに引っかからない' do
          aggregate_failures do
            expect(build_stubbed(:blog_article, content: nil).valid?).to be_falsy
            expect(build_stubbed(:blog_article, content: '').valid?).to be_falsy
            expect(build_stubbed(:blog_article, content: 'ナンパの極意 初級編の詳細はこちらです。').valid?).to be_truthy
          end
        end
      end

      context 'length' do
        it "#{Blog::Article::MAXIMUM_CONTENT_LENGTH}文字以下ならバリデーションに引っかからず、超えていたらバリデーションに引っかかる" do
          aggregate_failures do
            expect(build_stubbed(:blog_article, content: 'a' * (Blog::Article::MAXIMUM_CONTENT_LENGTH - 1)).valid?).to be_truthy
            expect(build_stubbed(:blog_article, content: 'a' * Blog::Article::MAXIMUM_CONTENT_LENGTH).valid?).to be_truthy
            expect(build_stubbed(:blog_article, content: 'a' * (Blog::Article::MAXIMUM_CONTENT_LENGTH + 1)).valid?).to be_falsy
          end
        end
      end
    end
  end
end
