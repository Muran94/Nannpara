require 'rails_helper'

describe BlogCommentDecorator do
  let(:blog_comment) { BlogComment.new.extend BlogCommentDecorator }
  subject { blog_comment }
  it { should be_a BlogComment }
end
