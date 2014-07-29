FactoryGirl.define do
  factory :user do
    name 'taro'
    email { "hoge#{ rand(10000) }@fuga.com" }
    password 'password'
    confirmed_at { 1.day.ago }
  end
end
