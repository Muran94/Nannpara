require 'rails_helper'

describe BlogArticleDecorator do
  let(:blog_article) { BlogArticle.new.extend BlogArticleDecorator }
  subject { blog_article }
  it { should be_a BlogArticle }
end
