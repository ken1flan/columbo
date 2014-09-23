class CreatePickupTweetsPerDays < ActiveRecord::Migration
  def change
    create_table :pickup_tweets_per_days do |t|
      t.date    :target_date,       null: false
      t.integer :pickup_keyword_id, null: false
      t.integer :total,             null: false, default: 0

      t.timestamps
    end

    add_index :pickup_tweets_per_days, :pickup_keyword_id
  end
end
