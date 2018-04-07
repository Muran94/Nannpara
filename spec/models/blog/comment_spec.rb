# == Schema Information
#
# Table name: blog_comments
#
#  id              :integer          not null, primary key
#  content         :text
#  user_id         :integer
#  blog_article_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Blog::Comment, type: :model do
  context "バリデーションテスト" do
    context "content" do
      context "presence" do
        it 'contentが nil か 空の場合バリデーションに引っかかり、そうでない場合はバリデーションに引っかからない' do
          aggregate_failures do
            expect(build_stubbed(:blog_comment, content: nil).valid?).to be_falsy
            expect(build_stubbed(:blog_comment, content: '').valid?).to be_falsy
            expect(build_stubbed(:blog_comment, content: 'ブログ拝見しました！とても深い考察で驚きました！').valid?).to be_truthy
          end
        end
      end

      context "length" do
        it "#{Blog::Comment::MAXIMUM_CONTENT_LENGTH}文字以下ならバリデーションに引っかからず、超えていたらバリデーションに引っかかる" do
          aggregate_failures do
            expect(build_stubbed(:blog_comment, content: 'a' * (Blog::Comment::MAXIMUM_CONTENT_LENGTH - 1)).valid?).to be_truthy
            expect(build_stubbed(:blog_comment, content: 'a' * Blog::Comment::MAXIMUM_CONTENT_LENGTH).valid?).to be_truthy
            expect(build_stubbed(:blog_comment, content: 'a' * (Blog::Comment::MAXIMUM_CONTENT_LENGTH + 1)).valid?).to be_falsy
          end
        end
      end
    end
  end
end
