FactoryGirl.define do
  factory :identity do
    user_id nil
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
