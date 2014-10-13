# == Schema Information
#
# Table name: pickup_keywords
#
#  id             :integer          not null, primary key
#  pickup_keyword :string(255)
#  slug           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class PickupKeyword < ActiveRecord::Base
  has_many :pickup_tweets_per_days

  def tweet_count
    PickupTweet.where(pickup_keyword_id: id).count
  end

  def self.best_of_yesterday
    sums = PickupTweetsPerDay.
      where(target_date: Date.yesterday).
      group(:pickup_keyword_id).sum(:total)
    if sums.present?
      find sums.sort_by{ |i| i[1] }.reverse.first[0]
    else
      nil
    end
  end

  def self.best_of_last_week
    sums = PickupTweetsPerDay.
      where("target_date <= ?", Date.yesterday).
      where("target_date >= ?", 8.days.ago.to_date).
      group(:pickup_keyword_id).sum(:total)
    if sums.present?
      find sums.sort_by{ |i| i[1] }.reverse.first[0]
    else
      nil
    end
  end

  def self.totals_of_yesterday
    PickupTweetsPerDay.
      yesterday.
      group("pickup_keywords.pickup_keyword").
      joins(:pickup_keyword).
      sum(:total)
  end

  def self.totals_of_last_week
    PickupTweetsPerDay.
      last_week.
      group("pickup_keywords.pickup_keyword").
      joins(:pickup_keyword).
      sum(:total)
  end

  def self.date_and_totals_of_last_week
    PickupKeyword.all.map do |k|
      records = PickupTweetsPerDay.
        where(pickup_keyword_id: k.id).
        last_week.
        select("target_date, total")
      data = records.map do |record|
        [record.target_date, record.total]
      end
      { name: k.pickup_keyword, data: data }
    end
  end
end
