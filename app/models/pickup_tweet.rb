class PickupTweet < ActiveRecord::Base
  has_reputation :likes, source: :user, aggregated_by: :sum

  default_scope { order('tweet_at DESC') }
  scope :can_display, ->{ where(truncated: false) }

  SEARCH_KEYWORDS = [
    "うちのカミさんが",
  ]

  BOT_KEYWORDS = %w(bot ボット ぼっと)

  MAX_RECORDS = 1000

  def is_liked_by?(user)
    evaluation = evaluations.where(source_id: user.id).first
    evaluation.blank? || evaluation.value == 0 ? false : true
  end

  def like_number
    reputation_for(:likes).to_i
  end

  def self.get_tweets
    twitter_config = {
      consumer_key: Rails.application.secrets.twitter_consumer_key,
      consumer_secret: Rails.application.secrets.twitter_consumer_secret,
    }
    client = Twitter::REST::Client.new(twitter_config)
    SEARCH_KEYWORDS.each do |keyword|
      tweets = client.search(keyword)
      tweets.each do |tweet|
        unless is_bot?(tweet)
          pickup_tweet_attrs = PickupTweet.get_attributes_from_tweet(tweet, keyword)
          PickupTweet.create_or_update(pickup_tweet_attrs)
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

  private
    def self.get_attributes_from_tweet(tweet, keyword)
      { attrs: tweet.attrs.to_s,
        tweet_id: tweet.id,
        text: tweet.text,
        tweet_at: tweet.created_at,
        truncated: tweet.truncated?,
        tweet_user_image_url: tweet.user.profile_image_url.to_s,
        tweet_user_name: tweet.user.name,
        tweet_user_screen_name: tweet.user.screen_name,
        keyword: keyword
      }
    end

    def self.create_or_update(attributes)
      pickup_tweet = PickupTweet.find_by(tweet_id: attributes[:tweet_id].to_s)
      if(pickup_tweet.blank?)
        pickup_tweet = new( attributes )
        pickup_tweet.save!
      else
        pickup_tweet.update_attributes( attributes )
      end
      pickup_tweet
    end

    def self.is_bot?(tweet)
      regex = BOT_KEYWORDS.map{|k| "(#{k})"}.join('|')
      !!(tweet.user.name =~ /#{regex}/ || tweet.user.screen_name =~ /#{regex}/)
    end
end
