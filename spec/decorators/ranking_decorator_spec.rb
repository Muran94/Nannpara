require 'rails_helper'

describe RankingDecorator do
  let(:ranking) { Ranking.new.extend RankingDecorator }
  subject { ranking }
  it { should be_a Ranking }
end
