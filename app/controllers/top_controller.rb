class TopController < ApplicationController
  def index
    @pickup_tweets = PickupTweet.can_display.page(params[:page])
    raise ActionController::RoutingError.new('Not Found') unless @pickup_tweets.present?
  end
end
