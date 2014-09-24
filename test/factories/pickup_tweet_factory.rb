# == Schema Information
#
# Table name: pickup_tweets
#
#  id                     :integer          not null, primary key
#  attrs                  :text
#  tweet_id               :string(255)
#  text                   :string(255)
#  truncated              :boolean
#  tweet_at               :datetime
#  tweet_user_image_url   :string(255)
#  tweet_user_name        :string(255)
#  tweet_user_screen_name :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  keyword                :string(255)
#  tweet_user_uid         :string(255)
#  pickup_keyword_id      :integer
#
# Indexes
#
#  index_pickup_tweets_on_pickup_keyword_id  (pickup_keyword_id)
#  index_pickup_tweets_on_tweet_at           (tweet_at)
#  index_pickup_tweets_on_tweet_id           (tweet_id)
#  index_pickup_tweets_on_tweet_user_name    (tweet_user_name)
#

FactoryGirl.define do
  factory :pickup_tweet do
    tweet_id                { rand(100000).to_s }
    text                    { "testtext#{tweet_id}" }
    truncated               false
    tweet_at                { 1.day.ago }
    tweet_user_image_url    "http://google.com"
    tweet_user_uid          { rand(100000).to_s }
    tweet_user_name         { "test_user_name#{tweet_user_uid}" }
    tweet_user_screen_name  { "test_screen_name#{tweet_user_uid}" }
    keyword                 "test_keyword"
    attrs                   {"
      {
        id: '#{rand(100000)}',
        text: 'てきすとてきすと',
        user:
          {
            id: #{tweet_user_uid},
            name: 'test_user_name',
            screen_name:'test_user_screen_name'
          }
      }
    "}
  end

  trait :truncated do
    truncated true
  end

  trait :bot do
    attrs {"
      {
        id: #{rand(100000)},
        text: 'てきすとてきすと',
        user:
          {
            id: #{rand(100000)},
            name: 'test_bot_user_name',
            screen_name:'test_bot_user_screen_name'
          }
      }
    "}
  end
end
