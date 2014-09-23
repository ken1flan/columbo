class CronController < ApplicationController
  def pickup_tweets
    PickupTweet.get_tweets
  end

  def housekeep_tweets
    PickupTweet.housekeep
  end

  def pickup_tweets_per_day
    PickupKeyword.all.each do |pickup_keyword|
      PickupTweetsPerDay.take_statistics(pickup_keyword)
    end
  end
end

