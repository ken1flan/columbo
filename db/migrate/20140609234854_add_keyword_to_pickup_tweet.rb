class AddKeywordToPickupTweet < ActiveRecord::Migration
  def change
    add_column :pickup_tweets, :keyword, :string
  end
end
