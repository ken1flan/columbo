json.array!(@excluded_twitter_users) do |excluded_twitter_user|
  json.extract! excluded_twitter_user, :id, :uid, :name, :screen_name, :memo
  json.url excluded_twitter_user_url(excluded_twitter_user, format: :json)
end
