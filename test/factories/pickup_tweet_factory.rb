FactoryGirl.define do
  factory :pickup_tweet do
    attrs                   {"
      id: #{rand(100000)},
      text: 'てきすとてきすと',
      user:
        {
          id: #{rand(100000)},
          name: 'test_user_name',
          screen_name:'test_user_screen_name'
        }
    "}
    tweet_id                { rand(100000).to_s }
    text                    { "testtext#{tweet_id}" }
    truncated               false
    tweet_at                { 1.day.ago }
    tweet_user_image_url    "http://google.com"
    tweet_user_uid          { rand(100000).to_s }
    tweet_user_name         { "test_user_name#{tweet_user_uid}" }
    tweet_user_screen_name  { "test_screen_name#{tweet_user_uid}" }
    keyword                 "test_keyword"
  end

  trait :truncated do
    truncated true
  end

  trait :bot do
    attrs {"
      id: #{rand(100000)},
      text: 'てきすとてきすと',
      user:
        {
          id: #{rand(100000)},
          name: 'test_bot_user_name',
          screen_name:'test_bot_user_screen_name'
        }
    "}
  end
end
