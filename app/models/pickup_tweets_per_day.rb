class PickupTweetsPerDay < ActiveRecord::Base
  def self.take_statistics(pickup_keyword)
    today = Time.zone.now.to_date
    pickup_tweets_per_day = find_by(target_date: today, pickup_keyword_id: pickup_keyword.id)

    if pickup_tweets_per_day.blank?
      pickup_tweets = PickupTweet.where(pickup_keyword_id: pickup_keyword.id).where("tweet_at >= ?", today)
      pickup_tweets_per_day = create(target_date: today, pickup_keyword_id: pickup_keyword.id, total: pickup_tweets.count)
    else
      old_count = pickup_tweets_per_day.total
      pickup_tweets = PickupTweet.where(pickup_keyword_id: pickup_keyword.id).where("tweet_at > ?", pickup_tweets_per_day.updated_at)
      pickup_tweets_per_day.update_attributes(total: old_count + pickup_tweets.count)
    end
  end
end
