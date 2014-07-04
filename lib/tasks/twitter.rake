namespace :twitter do
  desc "twitterから指定キーワードのtweetを集める"
  task :pickup_by_keyword => :environment do
    PickupTweet.get_tweets
  end

  desc "増えすぎたpickup tweetを古い方から削除する"
  task :housekeep => :environment do
    PickupTweet.housekeep
  end
end
