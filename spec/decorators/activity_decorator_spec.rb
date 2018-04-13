require 'rails_helper'

describe ActivityDecorator do
  let(:activity) { Activity.new.extend ActivityDecorator }
  subject { activity }
  it { should be_a Activity }
end
