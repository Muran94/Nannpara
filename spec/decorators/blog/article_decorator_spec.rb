require 'rails_helper'

describe Blog::ArticleDecorator do
  let(:article) { Blog::Article.new.extend Blog::ArticleDecorator }
  subject { article }
  it { should be_a Blog::Article }
end
