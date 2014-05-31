class TopController < ApplicationController
  def index
    @pickup_tweets = PickupTweet.can_display
  end
end
