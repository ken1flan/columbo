FactoryGirl.define do
  factory :user do
    name 'taro'
    email 'hoge@fuga.com'
    password 'password'
    confirmed_at { 1.day.ago }
  end
end
