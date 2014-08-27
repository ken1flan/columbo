namespace :onetime do
  desc '古い形式のpickup_tweetにtwitter_user_uidを追加する'
  task :add_twitter_user_uid_to_pickup_tweets => :environment do
    PickupTweet.all.each do |pickup_tweet|
      tweet = Twitter::Tweet.new(eval(pickup_tweet.attrs))
      if pickup_tweet.tweet_user_uid.blank?
        pickup_tweet.update_attributes(tweet_user_uid: tweet.user.id)
      end
    end
  end
end
