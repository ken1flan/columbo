namespace :twitter do
  desc "twitterから指定キーワードのtweetを集める"
  task :pickup_by_keyword => :environment do
    PickupTweet.get_tweets
  end
end
