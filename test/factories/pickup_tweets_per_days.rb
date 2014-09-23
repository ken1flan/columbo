# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pickup_tweets_per_day do
    target_date "2014-09-02"
    pickup_keyword_id 1
    total 1
  end
end
