require 'rails_helper'

describe Blog::CommentDecorator do
  let(:blog_comment) { Blog::Comment.new.extend Blog::CommentDecorator }
  subject { blog_comment }
  it { should be_a Blog::Comment }
end
