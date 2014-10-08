# == Schema Information
#
# Table name: pickup_keywords
#
#  id             :integer          not null, primary key
#  pickup_keyword :string(255)
#  slug           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

describe PickupKeyword do
  describe "#tweet_count" do
    before do
      @pickup_keyword = create(:pickup_keyword)
      @another_pickup_keyword = create(:pickup_keyword)
    end

    context "先週のpickup_tweets_per_dayが登録されていないとき" do
      it "0であること" do
        @pickup_keyword.tweet_count.must_equal 0
      end
    end

    context "idと一致するpickup_keywordのpickup_tweets_per_dayが1件登録されているとき" do
      before do
        create(:pickup_tweet, pickup_keyword_id: @pickup_keyword.id)
      end

      it "1であること" do
        @pickup_keyword.tweet_count.must_equal 1
      end
    end

    context "idと一致するpickup_keywordのpickup_tweetが2件登録されているとき" do
      before do
        create_list(:pickup_tweet, 2, pickup_keyword_id: @pickup_keyword.id)
      end

      it "2であること" do
        @pickup_keyword.tweet_count.must_equal 2
      end
    end

    context "idと一致しないpickup_keywordのpickup_tweetが1件登録されているとき" do
      before do
        create(:pickup_tweet, pickup_keyword_id: @another_pickup_keyword.id)
      end

      it "0であること" do
        @pickup_keyword.tweet_count.must_equal 0
      end
    end
  end

  describe ".best_of_yesterday" do
    before do
      Timecop.freeze
      @pickup_keyword = create(:pickup_keyword)
      @another_pickup_keyword = create(:pickup_keyword)
      @today = Date.today
      @yesterday = Date.yesterday
      @day_before_yesterday = 2.days.ago.to_date
    end
    after { Timecop.return }

    context "昨日のpickup_tweets_per_dayがないとき" do
      before do
        create(:pickup_tweets_per_day, target_date: @today, pickup_keyword_id: @pickup_keyword.id)
        create(:pickup_tweets_per_day, target_date: @today, pickup_keyword_id: @another_pickup_keyword.id)
        create(:pickup_tweets_per_day, target_date: @day_before_yesterday, pickup_keyword_id: @pickup_keyword.id)
        create(:pickup_tweets_per_day, target_date: @day_before_yesterday, pickup_keyword_id: @another_pickup_keyword.id)
      end

      it "nilであること" do
        PickupKeyword.best_of_yesterday.must_equal nil
      end
    end

    context "昨日のpickup_tweets_per_dayが1件のとき" do
      before do
        create(:pickup_tweets_per_day, target_date: @yesterday, pickup_keyword_id: @pickup_keyword.id, total: 2)
      end

      it "そのpickup_keywordであること" do
        PickupKeyword.best_of_yesterday.id.must_equal @pickup_keyword.id
      end
    end

    context "昨日のpickup_tweets_per_dayが2件のとき" do
      before do
        create(:pickup_tweets_per_day, target_date: @yesterday, pickup_keyword_id: @pickup_keyword.id, total: 2)
        create(:pickup_tweets_per_day, target_date: @yesterday, pickup_keyword_id: @another_pickup_keyword.id, total: 1)
      end

      it "totalの値が大きい方のpickup_keywordであること" do
        PickupKeyword.best_of_yesterday.id.must_equal @pickup_keyword.id
      end
    end
  end

  describe ".best_of_last_week" do
    before do
      Timecop.freeze
      @pickup_keyword = create(:pickup_keyword)
      @another_pickup_keyword = create(:pickup_keyword)
      @today = Date.today
      @yesterday = Date.yesterday
      @day_before_yesterday = 2.days.ago.to_date
    end
    after { Timecop.return }

    context "先週のpickup_tweets_per_dayが登録されていないとき" do
      before do
        create(:pickup_tweets_per_day, target_date: @today, pickup_keyword_id: @pickup_keyword.id, total: 2)
        create(:pickup_tweets_per_day, target_date: 9.days.ago.to_date, pickup_keyword_id: @pickup_keyword.id, total: 2)
      end

      it "nilであること" do
        PickupKeyword.best_of_last_week.must_equal nil
      end
    end

    context "昨日のpickup_tweets_per_dayが1件のとき" do
      before do
        create(:pickup_tweets_per_day, target_date: @yesterday, pickup_keyword_id: @pickup_keyword.id, total: 2)
      end

      it "そのpickup_keywordであること" do
        PickupKeyword.best_of_last_week.id.must_equal @pickup_keyword.id
      end
    end

    context "8日前のpickup_tweets_per_dayが1件のとき" do
      before do
        create(:pickup_tweets_per_day, target_date: 8.days.ago.to_date, pickup_keyword_id: @pickup_keyword.id, total: 2)
      end

      it "そのpickup_keywordであること" do
        PickupKeyword.best_of_last_week.id.must_equal @pickup_keyword.id
      end
    end

    context "昨日のpickup_tweets_per_dayが2件のとき" do
      before do
        create(:pickup_tweets_per_day, target_date: @yesterday, pickup_keyword_id: @pickup_keyword.id, total: 2)
        create(:pickup_tweets_per_day, target_date: @yesterday, pickup_keyword_id: @another_pickup_keyword.id, total: 1)
      end

      it "totalの値が大きい方のpickup_keywordであること" do
        PickupKeyword.best_of_last_week.id.must_equal @pickup_keyword.id
      end
    end
  end
end
