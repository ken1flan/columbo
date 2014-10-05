class PickupTweetsPerDaysController < ApplicationController
  def show
    # TODO: リファクタリング & テスト
    @pickup_keywords = PickupKeyword.all
    today = Date.today
    yesterday = Date.yesterday
    @target_dates = ( 8.days.ago.to_date..1.day.ago.to_date ).to_a.reverse
    @pickup_tweets_per_days = PickupTweetsPerDay.
      where("pickup_tweets_per_days.target_date >= ?", @target_dates.last).
      where("pickup_tweets_per_days.target_date <= ?", @target_dates.first).
      includes(:pickup_keyword)
  end
end
