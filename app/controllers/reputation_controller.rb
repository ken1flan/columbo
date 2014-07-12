class ReputationController < ApplicationController
  def pickup_tweet
    if user_signed_in?
      @pickup_tweet = PickupTweet.can_display.find(params[:id])
      @evaluation_value = params[:up_down] == 'down' ? 0 : 1
      @pickup_tweet.add_or_update_evaluation(:likes, @evaluation_value, current_user)
    else
      # TODO: ja.ymlを使うようにする
      @error_message = 'ログインが必要です'
    end
  end
end
