FactoryGirl.define do
  factory :user do
    name "ナンパ師１号"
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
  end
end
