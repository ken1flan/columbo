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

class PickupTweet < ActiveRecord::Base
  has_reputation :likes, source: :user, aggregated_by: :sum

  default_scope { order('tweet_at DESC') }
  scope :can_display, -> { where(truncated: false) }

  BOT_KEYWORDS = %w(bot ボット ぼっと)

  MAX_RECORDS = 2000

  # TODO: isを取る
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
    PickupKeyword.all.each do |pickup_keyword|
      tweets = client.search(pickup_keyword.pickup_keyword + "since:#{Date.today}")
      tweets.each do |tweet|
        unless non_pickup_tweet?(tweet)
          pickup_tweet_attrs = PickupTweet.get_attributes_from_tweet(tweet, pickup_keyword)
          PickupTweet.create_or_update(pickup_tweet_attrs)
        end
      end
    end
  end

  def self.housekeep
    self.transaction do
      self.order('tweet_at DESC').offset(MAX_RECORDS).each do |r|
        r.destroy
      end
    end
  end

  def self.cleanup
    all.each do |pickup_tweet|
      tweet = Twitter::Tweet.new(eval(pickup_tweet.attrs))
      pickup_tweet.delete if non_pickup_tweet?(tweet)
    end
  end

  private
    def self.get_attributes_from_tweet(tweet, pickup_keyword)
      { attrs: tweet.attrs.to_s,
        tweet_id: tweet.id,
        text: tweet.text,
        tweet_at: tweet.created_at,
        truncated: tweet.truncated?,
        tweet_user_image_url: tweet.user.profile_image_url.to_s,
        tweet_user_uid: tweet.user.id,
        tweet_user_name: tweet.user.name,
        tweet_user_screen_name: tweet.user.screen_name,
        keyword: pickup_keyword.pickup_keyword,
        pickup_keyword_id: pickup_keyword.id
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

    def self.non_pickup_tweet?(tweet)
      bot_tweet?(tweet) || excluded_twitter_user_tweet?(tweet)
    end

    def self.bot_tweet?(tweet)
      regex = BOT_KEYWORDS.map{|k| "(#{k})"}.join('|')
      !!(tweet.user.name =~ /#{regex}/i || tweet.user.screen_name =~ /#{regex}/)
    end

    def self.excluded_twitter_user_tweet?(tweet)
      ids = ExcludedTwitterUser.pluck(:uid)
      ids.include? tweet.user.id.to_s
    end
end
