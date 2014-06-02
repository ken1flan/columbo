class CreatePickupTweets < ActiveRecord::Migration
  def change
    create_table :pickup_tweets do |t|
      t.text :attrs
      t.string :tweet_id
      t.string :text
      t.boolean :truncated
      t.datetime :tweet_at
      t.string :tweet_user_image_url
      t.string :tweet_user_name
      t.string :tweet_user_screen_name

      t.timestamps
    end
    add_index :pickup_tweets, :tweet_id
    add_index :pickup_tweets, :tweet_at
    add_index :pickup_tweets, :tweet_user_name
  end
end
