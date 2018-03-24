require 'rails_helper'

describe UserDecorator do
  describe %(#format_introduction) do
    let(:user_with_introduction) { build_stubbed(:user, introduction: '初心者です！よろしく！').extend UserDecorator }
    let(:user_without_introduction) { build_stubbed(:user, introduction: '').extend UserDecorator }

    it %(introductionが 空 なら "#{UserDecorator::UNSET_MESSAGE}"、そうでなければintroductionを返す) do
      aggregate_failures do
        expect(user_with_introduction.format_introduction).to eq user_with_introduction.introduction
        expect(user_without_introduction.format_introduction).to eq UserDecorator::UNSET_MESSAGE
      end
    end
  end

  describe %(#format_age) do
    let(:user_with_age) { build_stubbed(:user, age: 20).extend UserDecorator }
    let(:user_without_age) { build_stubbed(:user, age: nil).extend UserDecorator }

    it %(ageが 空 なら "#{UserDecorator::UNSET_MESSAGE}"、そうでなければageを返す) do
      aggregate_failures do
        expect(user_with_age.format_age).to eq "#{user_with_age.age}歳"
        expect(user_without_age.format_age).to eq UserDecorator::UNSET_MESSAGE
      end
    end
  end

  describe %(#format_prefecture) do
    let(:user_with_prefecture_code) { build_stubbed(:user, prefecture_code: 13).extend UserDecorator }
    let(:user_without_prefecture_code) { build_stubbed(:user, prefecture_code: nil).extend UserDecorator }

    it %(prefecture_codeが 空 なら "#{UserDecorator::UNSET_MESSAGE}"、そうでなければprefecture.nameを返す) do
      aggregate_failures do
        expect(user_with_prefecture_code.format_prefecture).to eq user_with_prefecture_code.prefecture.name
        expect(user_without_prefecture_code.format_prefecture).to eq UserDecorator::UNSET_MESSAGE
      end
    end
  end

  describe %(#format_experience) do
    let(:user_with_experience) { build_stubbed(:user, experience: '3年').extend UserDecorator }
    let(:user_without_experience) { build_stubbed(:user, experience: nil).extend UserDecorator }

    it %(experienceが 空 なら "#{UserDecorator::UNSET_MESSAGE}"、そうでなければexperienceを返す) do
      aggregate_failures do
        expect(user_with_experience.format_experience).to eq user_with_experience.experience
        expect(user_without_experience.format_experience).to eq UserDecorator::UNSET_MESSAGE
      end
    end
  end
end
