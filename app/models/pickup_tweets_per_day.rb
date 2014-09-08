class PickupTweetsPerDay < ActiveRecord::Base
  def update_statistics
    pickup_tweets = PickupTweet.
      where(pickup_keyword_id: self.id).
      where("tweet_at > ?", self.updated_at).
      where("tweet_at < ?", self.target_date + 1.day)
    self.update_attributes(total: self.total + pickup_tweets.count)
  end

  def self.take_statistics(pickup_keyword)
    today = Time.zone.now.to_date
    pickup_tweets_per_day = find_by(target_date: today, pickup_keyword_id: pickup_keyword.id)

    if pickup_tweets_per_day.blank?
      # 当日分がまだなければ、前日分の集計が残っているはずなので、前日分も集計する
      # 前日分がみつからない場合は何もしない

      yesterday = today - 1.day
      pickup_tweets_per_day_yesterday = find_by(target_date: yesterday, pickup_keyword_id: pickup_keyword.id)
      if pickup_tweets_per_day_yesterday.present?
        pickup_tweets_per_day_yesterday.update_statistics
      end

      pickup_tweets = PickupTweet.where(pickup_keyword_id: pickup_keyword.id).where("tweet_at >= ?", today)
      pickup_tweets_per_day = create(target_date: today, pickup_keyword_id: pickup_keyword.id, total: pickup_tweets.count)
    else
      pickup_tweets_per_day.update_statistics
    end
  end
end
