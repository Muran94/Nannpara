FactoryGirl.define do
  factory :message do
    association :recruitment

    message "ナンパ初心者です！よろしくお願いいたします！"
  end
end
