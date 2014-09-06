require "test_helper"

describe PickupTweetsPerDay do
  before { Timecop.freeze }
  after { Timecop.return }

  describe "take_statistics" do
    before do
      @target_pickup_keyword = create(:pickup_keyword)
      @another_pickup_keyword = create(:pickup_keyword)
    end

    context "2014/01/01 00:00:00のとき" do
      before do
        @now = Time.local(2014, 1, 1, 0, 0, 0)
        Timecop.travel(@now)
        @yesterday = 1.day.ago
      end

      context "pickup_tweets_per_dayがないとき" do
        context "対象のpickup_tweetがないとき" do
          before do
            create(:pickup_tweet, tweet_at: @now, pickup_keyword_id: @another_pickup_keyword.id)
            create(:pickup_tweet, tweet_at: @yesterday, pickup_keyword_id: @target_pickup_keyword.id)
          end

          it '0でcreateされていること' do
            PickupTweetsPerDay.take_statistics(@target_pickup_keyword)
            check_value(@now.to_date, @target_pickup_keyword, 0)
          end
        end

        context "対象のpickup_tweetが1件あるとき" do
          before do
            create(:pickup_tweet, tweet_at: @now, pickup_keyword_id: @target_pickup_keyword.id)
            create(:pickup_tweet, tweet_at: @now, pickup_keyword_id: @another_pickup_keyword.id)
            create(:pickup_tweet, tweet_at: @yesterday, pickup_keyword_id: @target_pickup_keyword.id)
          end

          it '1でcreateされていること' do
            PickupTweetsPerDay.take_statistics(@target_pickup_keyword)
            check_value(@now.to_date, @target_pickup_keyword, 1)
          end
        end
      end

      context "pickup_tweets_per_dayが3件で登録されているとき" do
        before do
          create(:pickup_tweets_per_day, target_date: @now, total: 3)
        end

        context "対象のpickup_tweetがないとき" do
          before do
            create(:pickup_tweet, tweet_at: @now, pickup_keyword_id: @another_pickup_keyword.id)
            create(:pickup_tweet, tweet_at: @yesterday, pickup_keyword_id: @target_pickup_keyword.id)
          end

          it '3であること' do
            PickupTweetsPerDay.take_statistics(@target_pickup_keyword)
            check_value(@now.to_date, @target_pickup_keyword, 3)
          end
        end
      end
    end

    context "2014/01/01 01:00のとき" do
    end
  end

  def check_value(day, pickup_keyword, expected_value)
    statistics = PickupTweetsPerDay.find_by(target_date: day, pickup_keyword_id: pickup_keyword.id)
    statistics.target_date.must_equal day
    statistics.pickup_keyword_id.must_equal pickup_keyword.id
    statistics.total.must_equal expected_value
  end
end
