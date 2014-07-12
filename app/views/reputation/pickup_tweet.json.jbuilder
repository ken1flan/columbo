json.error_message @error_message
if @pickup_tweet.present?
  json.id @pickup_tweet.id
  json.evaluation_value @evaluation_value
  json.likes_count @pickup_tweet.reputation_for(:likes).to_i
end
