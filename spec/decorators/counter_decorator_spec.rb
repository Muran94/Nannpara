require 'rails_helper'

describe CounterDecorator do
  let(:counter) { Counter.new.extend CounterDecorator }
  subject { counter }
  it { should be_a Counter }
end
