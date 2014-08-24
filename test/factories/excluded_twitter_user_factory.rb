FactoryGirl.define do
  factory :excluded_twitter_user do
    uid { rand(10000000).to_s }
    name { "name_#{rand(100)}" }
    screen_name { "screen_name_#{rand(100)}" }
    memo { "めもめも#{rand(100)}" }
  end
end
