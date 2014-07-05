class CronController < ApplicationController
  def pickup_tweets
    PickupTweet.get_tweets
  end

  def housekeep_tweets
    PickupTweet.housekeep
  end
end

