class PickupTweet < ActiveRecord::Base

  default_scope { order('tweet_at DESC') }
  scope :can_display, ->{ where(truncated: false) }

  SEARCH_KEYWORDS = [
    "うちのカミさんが",
  ]

  MAX_RECORDS = 1000

  def self.get_tweets
    twitter_config = {
      consumer_key: Rails.application.secrets.twitter_consumer_key,
      consumer_secret: Rails.application.secrets.twitter_consumer_secret,
    }
    client = Twitter::REST::Client.new(twitter_config)
    SEARCH_KEYWORDS.each do |keyword|
      tweets = client.search(keyword)
      tweets.each do |tweet|
        pickup_tweet = PickupTweet.find_by(tweet_id: tweet.id.to_s)
        if(pickup_tweet.blank?)
          pickup_tweet = new(
            keyword: keyword,
            attrs: tweet.attrs.to_s,
            tweet_id: tweet.id,
            text: tweet.text,
            tweet_at: tweet.created_at,
            truncated: tweet.truncated?,
            tweet_user_image_url: tweet.user.profile_image_url.to_s,
            tweet_user_name: tweet.user.name,
            tweet_user_screen_name: tweet.user.screen_name,
          )
          pickup_tweet.save!
        else
          pickup_tweet.update_attributes(truncated: tweet.truncated?)
        end
      end
    end
  end

  def self.housekeep
    self.transaction do
      self.order('tweet_at DESC').offset(MAX_RECORDS).each do |r|
        r.delete
      end
    end
  end
end
