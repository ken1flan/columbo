class TopController < ApplicationController
  def index
    @pickup_tweets = PickupTweet.can_display.page(params[:page])
  end
end
