class AddToTweetUserUidToPickupTweet < ActiveRecord::Migration
  def change
    add_column :pickup_tweets, :tweet_user_uid, :string
  end
end
