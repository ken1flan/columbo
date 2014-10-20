class InitSchema < ActiveRecord::Migration
  def up
    
    create_table "identities", force: true do |t|
      t.integer  "user_id"
      t.string   "provider"
      t.string   "uid"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    add_index "identities", ["user_id"], name: "index_identities_on_user_id"
    
    create_table "pickup_tweets", force: true do |t|
      t.text     "attrs"
      t.string   "tweet_id"
      t.string   "text"
      t.boolean  "truncated"
      t.datetime "tweet_at"
      t.string   "tweet_user_image_url"
      t.string   "tweet_user_name"
      t.string   "tweet_user_screen_name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "keyword"
    end
    
    add_index "pickup_tweets", ["tweet_at"], name: "index_pickup_tweets_on_tweet_at"
    add_index "pickup_tweets", ["tweet_id"], name: "index_pickup_tweets_on_tweet_id"
    add_index "pickup_tweets", ["tweet_user_name"], name: "index_pickup_tweets_on_tweet_user_name"
    
    create_table "rs_evaluations", force: true do |t|
      t.string   "reputation_name"
      t.integer  "source_id"
      t.string   "source_type"
      t.integer  "target_id"
      t.string   "target_type"
      t.float    "value",           default: 0.0
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    add_index "rs_evaluations", ["reputation_name", "source_id", "source_type", "target_id", "target_type"], name: "index_rs_evaluations_on_reputation_name_and_source_and_target", unique: true
    add_index "rs_evaluations", ["reputation_name"], name: "index_rs_evaluations_on_reputation_name"
    add_index "rs_evaluations", ["source_id", "source_type"], name: "index_rs_evaluations_on_source_id_and_source_type"
    add_index "rs_evaluations", ["target_id", "target_type"], name: "index_rs_evaluations_on_target_id_and_target_type"
    
    create_table "rs_reputation_messages", force: true do |t|
      t.integer  "sender_id"
      t.string   "sender_type"
      t.integer  "receiver_id"
      t.float    "weight",      default: 1.0
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    add_index "rs_reputation_messages", ["receiver_id", "sender_id", "sender_type"], name: "index_rs_reputation_messages_on_receiver_id_and_sender", unique: true
    add_index "rs_reputation_messages", ["receiver_id"], name: "index_rs_reputation_messages_on_receiver_id"
    add_index "rs_reputation_messages", ["sender_id", "sender_type"], name: "index_rs_reputation_messages_on_sender_id_and_sender_type"
    
    create_table "rs_reputations", force: true do |t|
      t.string   "reputation_name"
      t.float    "value",           default: 0.0
      t.string   "aggregated_by"
      t.integer  "target_id"
      t.string   "target_type"
      t.boolean  "active",          default: true
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    add_index "rs_reputations", ["reputation_name", "target_id", "target_type"], name: "index_rs_reputations_on_reputation_name_and_target", unique: true
    add_index "rs_reputations", ["reputation_name"], name: "index_rs_reputations_on_reputation_name"
    add_index "rs_reputations", ["target_id", "target_type"], name: "index_rs_reputations_on_target_id_and_target_type"
    
    create_table "users", force: true do |t|
      t.string   "name"
      t.string   "email",                  default: "", null: false
      t.string   "encrypted_password",     default: "", null: false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",          default: 0,  null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.string   "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string   "unconfirmed_email"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    add_index "users", ["email"], name: "index_users_on_email", unique: true
    add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    
  end

  def down
    raise "Can not revert initial migration"
  end
end