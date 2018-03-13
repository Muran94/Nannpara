require 'rails_helper'

describe RecruitmentDecorator do
  let(:recruitment) { Recruitment.new.extend RecruitmentDecorator }
  subject { recruitment }
  it { should be_a Recruitment }
end
