# == Schema Information
#
# Table name: pickup_tweets_per_days
#
#  id                :integer          not null, primary key
#  target_date       :date             not null
#  pickup_keyword_id :integer          not null
#  total             :integer          default(0), not null
#  created_at        :datetime
#  updated_at        :datetime
#
# Indexes
#
#  index_pickup_tweets_per_days_on_pickup_keyword_id  (pickup_keyword_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pickup_tweets_per_day do
    target_date "2014-09-02"
    pickup_keyword_id 1
    total 1
  end
end
