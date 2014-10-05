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
end
