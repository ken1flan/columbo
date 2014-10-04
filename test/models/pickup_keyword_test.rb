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
    let(:pickup_keyword) { create(:pickup_keyword) }
    let(:another_pickup_keyword) { create(:pickup_keyword) }

    context "pickup_tweetが登録されていないとき" do
      it "0であること" do
        pickup_keyword.tweet_count.must_equal 0
      end
    end

    context "idと一致するpickup_keywordのpickup_tweetが1件登録されているとき" do
      before do
        create(:pickup_tweet, pickup_keyword_id: pickup_keyword.id)
      end

      it "1であること" do
        pickup_keyword.tweet_count.must_equal 1
      end
    end

    context "idと一致するpickup_keywordのpickup_tweetが2件登録されているとき" do
      before do
        create_list(:pickup_tweet, 2, pickup_keyword_id: pickup_keyword.id)
      end

      it "2であること" do
        pickup_keyword.tweet_count.must_equal 2
      end
    end

    context "idと一致しないpickup_keywordのpickup_tweetが1件登録されているとき" do
      before do
        create(:pickup_tweet, pickup_keyword_id: another_pickup_keyword.id)
      end

      it "0であること" do
        pickup_keyword.tweet_count.must_equal 0
      end
    end

  end
end
