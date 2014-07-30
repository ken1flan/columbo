FactoryGirl.define do
  factory :identity do
    user_id 1
    provider 'twitter'
    uid 1
  end

  trait :twitter do
    provider 'twitter'
  end

  trait :facebook do
    provider 'facebook'
  end
end
