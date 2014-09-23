class AddPickupKeywordIdToPickupTweet < ActiveRecord::Migration
  def change
    add_column :pickup_tweets, :pickup_keyword_id, :integer
    add_index :pickup_tweets, :pickup_keyword_id
  end
end
