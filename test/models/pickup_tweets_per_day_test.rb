# == Schema Information
#
# Table name: pickup_tweets_per_days
#
#  id                :integer          not null, primary key
#  target_date       :date             not null
#  pickup_keyword_id :integer          not null
#  total             :integer          default(0), not null
#  created_at        :datetime
#  updated_at        :datetime
#
# Indexes
#
#  index_pickup_tweets_per_days_on_pickup_keyword_id  (pickup_keyword_id)
#

require "test_helper"

describe PickupTweetsPerDay do
  before { Timecop.freeze }
  after { Timecop.return }

  describe ".create_statistics" do
    before do
      @now = Time.gm(2014, 1, 1, 3, 0, 0)
      Timecop.travel(@now)
      @pickup_keyword = create(:pickup_keyword)
      @another_pickup_keyword = create(:pickup_keyword)
      @target_date = @now.to_date
    end

    context "指定日のpickup_tweetがないとき" do
      before do
        @result = PickupTweetsPerDay.create_statistics(@target_date, @pickup_keyword)
      end

      it "total = 0で作られること" do
        @result.total.must_equal 0
      end
    end

    context "指定日のpickup_tweetが1つあるとき" do
      before do
        create(:pickup_tweet, tweet_at: 1.hour.ago, pickup_keyword_id: @pickup_keyword.id)
        create(:pickup_tweet, tweet_at: 1.hour.ago, pickup_keyword_id: @another_pickup_keyword.id)
        create(:pickup_tweet, tweet_at: 1.day.ago, pickup_keyword_id: @pickup_keyword.id)
        @result = PickupTweetsPerDay.create_statistics(@target_date, @pickup_keyword)
      end

      it "total = 1で作られること" do
        @result.total.must_equal 1
      end
    end

    context "指定日のpickup_tweetが2つあるとき" do
      before do
        create_list(:pickup_tweet, 2, tweet_at: 1.hour.ago, pickup_keyword_id: @pickup_keyword.id)
        @result = PickupTweetsPerDay.create_statistics(@target_date, @pickup_keyword)
      end

      it "total = 2で作られること" do
        @result.total.must_equal 2
      end
    end
  end

  describe "#update_statistics" do
    before do
      @now = Time.gm(2014, 1, 1, 3, 0, 0)
      Timecop.travel(@now)
      @pickup_keyword = create(:pickup_keyword)
      @another_pickup_keyword = create(:pickup_keyword)
      @target_date = @now.to_date
    end

    context "1時間前にtotal = 1で作れていたとき" do
      before do
        @pickup_tweets_per_day = create(:pickup_tweets_per_day, target_date: @target_date, pickup_keyword_id: @pickup_keyword.id, total: 1, created_at: 1.hour.ago, updated_at: 1.hour.ago)
      end

      context "2時間前のツイートが2件あるとき" do
        before do
          create_list(:pickup_tweet, 2, tweet_at: 2.hours.ago, pickup_keyword_id: @pickup_keyword.id)
        end

        it "total = 1のままであること" do
          @pickup_tweets_per_day.update_statistics
          @pickup_tweets_per_day.total.must_equal 1
        end
      end

      context "30分前のツイートが2件あるとき" do
        before do
          create_list(:pickup_tweet, 2, tweet_at: 30.minutes.ago, pickup_keyword_id: @pickup_keyword.id)
        end

        it "total = 3になること" do
          @pickup_tweets_per_day.update_statistics
          @pickup_tweets_per_day.total.must_equal 3
        end
      end

      context "別のpickup_keywordで30分前のツイートが2件あるとき" do
        before do
          create_list(:pickup_tweet, 2, tweet_at: 30.minutes.ago, pickup_keyword_id: @another_pickup_keyword.id)
        end

        it "total = 1になること" do
          @pickup_tweets_per_day.update_statistics
          @pickup_tweets_per_day.total.must_equal 1
        end
      end
    end
  end

  describe ".take_statistics" do
    before do
      @target_pickup_keyword = create(:pickup_keyword)
      @another_pickup_keyword = create(:pickup_keyword)
    end

    context "2014/01/01 03:00:00のとき" do
      before do
        @now = Time.gm(2014, 1, 1, 3, 0, 0)
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

      context "pickup_tweets_per_dayが2:00に3件で登録されているとき" do
        before do
          @one_hour_ago = @now - 1.hour
          create(:pickup_tweets_per_day, target_date: @now, total: 3, updated_at: @one_hour_ago)
        end

        context "対象のpickup_tweetがないとき" do
          before do
            create(:pickup_tweet, tweet_at: @now, pickup_keyword_id: @another_pickup_keyword.id)
            create(:pickup_tweet, tweet_at: @yesterday, pickup_keyword_id: @target_pickup_keyword.id)
            create(:pickup_tweet, tweet_at: @one_hour_ago, pickup_keyword_id: @target_pickup_keyword.id)
            PickupTweetsPerDay.take_statistics(@target_pickup_keyword)
          end

          it "3であること" do
            check_value(@now.to_date, @target_pickup_keyword, 3)
          end
        end

        context "対象のpickup_tweetが1件あったとき" do
          before do
            create(:pickup_tweet, tweet_at: @now, pickup_keyword_id: @another_pickup_keyword.id)
            create(:pickup_tweet, tweet_at: @yesterday, pickup_keyword_id: @target_pickup_keyword.id)
            create(:pickup_tweet, tweet_at: @one_hour_ago, pickup_keyword_id: @target_pickup_keyword.id)
            create(:pickup_tweet, tweet_at: (@one_hour_ago + 1.second ), pickup_keyword_id: @target_pickup_keyword.id)
            PickupTweetsPerDay.take_statistics(@target_pickup_keyword)
          end

          it "4であること" do
            check_value(@now.to_date, @target_pickup_keyword, 4)
          end
        end
      end
    end
  end

  def check_value(day, pickup_keyword, expected_value)
    statistic_count = PickupTweetsPerDay.where(target_date: day, pickup_keyword_id: pickup_keyword.id).count
    statistic_count.must_equal 1

    statistic = PickupTweetsPerDay.find_by(target_date: day, pickup_keyword_id: pickup_keyword.id)
    statistic.target_date.must_equal day
    statistic.pickup_keyword_id.must_equal pickup_keyword.id
    statistic.total.must_equal expected_value
  end
end
