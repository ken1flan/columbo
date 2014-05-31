class PickupTweet < ActiveRecord::Base

  scope :can_display, ->{ where(truncated: false) }

  SEARCH_CONDITIONS = [
    "うちのカミさんが",
  ]

  def self.get_tweets
    twitter_config = {
      consumer_key: Rails.application.secrets.twitter_consumer_key,
      consumer_secret: Rails.application.secrets.twitter_consumer_secret,
    }
    client = Twitter::REST::Client.new(twitter_config)
    SEARCH_CONDITIONS.each do |condition|
      tweets = client.search(condition)
      tweets.each do |tweet|
        pickup_tweet = PickupTweet.find_by(tweet_id: tweet.id)
        if(pickup_tweet.blank?)
          pickup_tweet = new(
            attrs: tweet.attrs.to_s,
            tweet_id: tweet.id,
            text: tweet.text,
            tweet_at: tweet.created_at,
            truncated: tweet.truncated?,
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
end
