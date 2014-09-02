class CreatePickupTweetsPerDays < ActiveRecord::Migration
  def change
    create_table :pickup_tweets_per_days do |t|
      t.date :target_date
      t.integer :pickup_keyword_id
      t.integer :total

      t.timestamps
    end
  end
end
