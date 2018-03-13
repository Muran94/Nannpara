require 'rails_helper'

describe MessageDecorator do
  let(:message) { Message.new.extend MessageDecorator }
  subject { message }
  it { should be_a Message }
end
