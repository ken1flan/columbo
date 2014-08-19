class CreateExcludedTwitterUsers < ActiveRecord::Migration
  def change
    create_table :excluded_twitter_users do |t|
      t.string :uid
      t.string :name
      t.string :screen_name
      t.string :memo

      t.timestamps
    end
  end
end
