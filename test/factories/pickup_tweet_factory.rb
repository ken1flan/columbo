FactoryGirl.define do
  factory :pickup_tweet do
    attrs                   "test_attrs"
    tweet_id                1
    text                    "testtext"
    truncated               false
    tweet_at                { 1.day.ago }
    tweet_user_image_url    "http://google.com"
    tweet_user_name         "test_user_name"
    tweet_user_screen_name  "test_screen_name"
    keyword                 "test_keyword"
  end

  trait :truncated do
    truncated true
  end
end
