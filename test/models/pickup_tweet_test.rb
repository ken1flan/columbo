# == Schema Information
#
# Table name: pickup_tweets
#
#  id                     :integer          not null, primary key
#  attrs                  :text
#  tweet_id               :string(255)
#  text                   :string(255)
#  truncated              :boolean
#  tweet_at               :datetime
#  tweet_user_image_url   :string(255)
#  tweet_user_name        :string(255)
#  tweet_user_screen_name :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  keyword                :string(255)
#  tweet_user_uid         :string(255)
#  pickup_keyword_id      :integer
#
# Indexes
#
#  index_pickup_tweets_on_pickup_keyword_id  (pickup_keyword_id)
#  index_pickup_tweets_on_tweet_at           (tweet_at)
#  index_pickup_tweets_on_tweet_id           (tweet_id)
#  index_pickup_tweets_on_tweet_user_name    (tweet_user_name)
#

require "test_helper"

describe PickupTweet do
  describe "default_scope" do
    context "1〜3日前のツイートが登録されているとき" do
      before do
        @tweet1 = create(:pickup_tweet, tweet_at: 1.day.ago)
        @tweet2 = create(:pickup_tweet, tweet_at: 2.day.ago)
        @tweet3 = create(:pickup_tweet, tweet_at: 3.day.ago)
        @tweets = PickupTweet.all
      end

      it "ツイート時間が古い順に選択されること" do
        @tweets[0].id = @tweet3
        @tweets[1].id = @tweet2
        @tweets[2].id = @tweet1
      end
    end
  end

  describe ".can_display" do
    context "削除済みのツイートとそうでないツイートがあるとき" do
      before do
        @tweet = create(:pickup_tweet)
        @truncated_tweet = create(:pickup_tweet, :truncated)
        @tweets = PickupTweet.can_display
      end

      it "削除済みのツイートは選択されないこと" do
        @tweets.select{|t| t.id == @tweet.id}.present?.must_equal true
        @tweets.select{|t| t.id == @truncated_tweet.id}.blank?.must_equal true
      end
    end
  end

  describe "#is_liked_by?" do
    before do
      @user = create(:user)
      @pickup_tweet = create(:pickup_tweet)
    end

    context "userがlikeをしていないとき" do
      it "falseであること" do
        ret = @pickup_tweet.is_liked_by?(@user)
        ret.must_equal(false)
      end
    end

    context "userがlikeをしたとき" do
      before do
        @pickup_tweet.add_or_update_evaluation(:likes, 1, @user)
      end

      it "trueであること" do
        ret = @pickup_tweet.is_liked_by?(@user)
        ret.must_equal(true)
      end
    end

    context "userがlikeをしたあと取り消したとき" do
      before do
        @pickup_tweet.add_or_update_evaluation(:likes, 1, @user)
        @pickup_tweet.add_or_update_evaluation(:likes, 0, @user)
      end

      it "falseであること" do
        ret = @pickup_tweet.is_liked_by?(@user)
        ret.must_equal(false)
      end
    end
  end

  describe "#like_number" do
    before do
      @users = create_list(:user, 2)
      @pickup_tweet = create(:pickup_tweet)
    end

    context "誰もlikeしてないとき" do
      it "0であること" do
        ret = @pickup_tweet.like_number
        ret.must_equal(0)
      end
    end

    context "likeしたが、取り消したひとがいるとき" do
      before do
        @pickup_tweet.add_or_update_evaluation(:likes, 1, @users[0])
        @pickup_tweet.add_or_update_evaluation(:likes, 0, @users[0])
      end

      it "0であること" do
        ret = @pickup_tweet.like_number
        ret.must_equal(0)
      end
    end

    context "likeしたひとが1人いるとき" do
      before do
        @pickup_tweet.add_or_update_evaluation(:likes, 1, @users[0])
      end

      it "1であること" do
        ret = @pickup_tweet.like_number
        ret.must_equal(1)
      end
    end

    context "likeしたひとが2人いるとき" do
      before do
        @pickup_tweet.add_or_update_evaluation(:likes, 1, @users[0])
        @pickup_tweet.add_or_update_evaluation(:likes, 1, @users[1])
      end

      it "1であること" do
        ret = @pickup_tweet.like_number
        ret.must_equal(2)
      end
    end
  end

  # TODO: Twitterのモックを作る
  #describe ".get_tweets" do
  #end

  describe ".housekeep" do
    context "#{PickupTweet::MAX_RECORDS}件登録されているとき" do
      before do
        create_list(:pickup_tweet, PickupTweet::MAX_RECORDS)
        PickupTweet.housekeep
      end

      it "登録件数が変わらないこと" do
        PickupTweet.count.must_equal(PickupTweet::MAX_RECORDS)
      end
    end

    context "#{PickupTweet::MAX_RECORDS + 1}件登録されているとき" do
      before do
        create_list(:pickup_tweet, PickupTweet::MAX_RECORDS)
        @oldest = create(:pickup_tweet, tweet_at: 100.years.ago)
        PickupTweet.housekeep
      end

      it "登録件数が#{PickupTweet::MAX_RECORDS}であること" do
        PickupTweet.count.must_equal(PickupTweet::MAX_RECORDS)
      end

      it "一番前につぶやかれたレコードが削除されていること" do
        proc { PickupTweet.find(@oldest.id) }.must_raise(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe ".cleanup" do
    before do
      @normal = create(:pickup_tweet)
    end

    context "botのツイートがあったとき" do
      before do
        @bot = create(:pickup_tweet, :bot)
      end

      it "削除されていること" do
        PickupTweet.cleanup
        all = PickupTweet.all
        all.include?(@bot).must_equal false
        all.include?(@normal).must_equal true
      end
    end

    context "除外twitter ユーザのツイートがあったとき" do
      before do
        @excluded_twitter_user = create(:excluded_twitter_user)
        @excluded = create(:pickup_tweet, tweet_user_uid: @excluded_twitter_user.uid)
      end

      it "削除されていること" do
        PickupTweet.cleanup
        all = PickupTweet.all
        all.include?(@excluded).must_equal false
        all.include?(@normal).must_equal true
      end
    end
  end

  describe ".get_attributes_from_tweet(tweet, pickup_keyword)" do
    context "tweetとpickup_keywordが指定されているとき" do
      before do
        @tweet_attrs = {
          id: 100,
          text: "tweet_text",
          tweet_at: 1.day.ago,
          truncated: false,
          user: {
            id: 200,
            name: "tweet_user_name",
            screen_name: "tweet_user_screen_name",
          }
        }
        @tweet = Twitter::Tweet.new(@tweet_attrs)
        @pickup_keyword = create(:pickup_keyword)

        @result = PickupTweet.get_attributes_from_tweet(@tweet, @pickup_keyword)
      end

      it "tweet内容とkeywordが設定されていること" do
        @result[:attrs].must_equal(@tweet.attrs.to_s)
        @result[:tweet_id].must_equal(@tweet.id)
        @result[:text].must_equal(@tweet.text)
        @result[:truncated].must_equal(@tweet.truncated?)
        # TODO: profile_image_urlをどうやって指定するか調べる
        # @result[:tweet_user_image_url].must_equal(@tweet.user.profile_image_url)
        @result[:tweet_user_uid].must_equal(@tweet.user.id)
        @result[:tweet_user_name].must_equal(@tweet.user.name)
        @result[:tweet_user_screen_name].must_equal(@tweet.user.screen_name)
        @result[:pickup_keyword_id].must_equal(@pickup_keyword.id)
      end
    end
  end

  describe ".create_or_update" do
    before do
      @attributes = { attrs: "tweet.attrs",
                      tweet_id: 100.to_s,
                      text: "tweet.text",
                      tweet_at: 1.day.ago,
                      truncated: false,
                      tweet_user_image_url: "tweet.user.profile_image_url",
                      tweet_user_name: "tweet.user.name",
                      tweet_user_screen_name: "tweet.user.screen_name",
                      pickup_keyword_id: 1
      }
    end

    context "DBに登録されていないtweet_idのとき" do
      it "正しく登録されていること" do
        PickupTweet.create_or_update(@attributes)
        @result = PickupTweet.find_by(tweet_id: @attributes[:tweet_id])
        @result.tweet_id.must_equal(@attributes[:tweet_id])
        @result.text.must_equal(@attributes[:text])
        @result.truncated.must_equal(@attributes[:truncated])
        @result.tweet_user_image_url.must_equal(@attributes[:tweet_user_image_url])
        @result.tweet_user_name.must_equal(@attributes[:tweet_user_name])
        @result.tweet_user_screen_name.must_equal(@attributes[:tweet_user_screen_name])
        @result.pickup_keyword_id.must_equal(@attributes[:pickup_keyword_id])
      end
    end

    context "DBに登録されているtweet_idのとき" do
      before do
        PickupTweet.create_or_update(@attributes)
        @original = PickupTweet.find_by(tweet_id: @attributes[:tweet_id])
        @updated_attributes = { attrs: "updated_tweet.attrs",
                                tweet_id: @attributes[:tweet_id],
                                text: "updated_tweet.text",
                                tweet_at: 1.hour.ago,
                                truncated: false,
                                tweet_user_image_url: "updated_tweet.user.profile_image_url",
                                tweet_user_name: "updated_tweet.user.name",
                                tweet_user_screen_name: "updated_tweet.user.screen_name",
                                pickup_keyword_id: 2
        }
        PickupTweet.create_or_update(@updated_attributes)
        @result = PickupTweet.find_by(tweet_id: @attributes[:tweet_id])
      end

      it "正しく更新されていること" do
        @result.id.must_equal(@original.id)
        @result.tweet_id.must_equal(@original.tweet_id)

        @result.text.must_equal(@updated_attributes[:text])
        @result.truncated.must_equal(@updated_attributes[:truncated])
        @result.tweet_user_image_url.must_equal(@updated_attributes[:tweet_user_image_url])
        @result.tweet_user_name.must_equal(@updated_attributes[:tweet_user_name])
        @result.tweet_user_screen_name.must_equal(@updated_attributes[:tweet_user_screen_name])
        @result.pickup_keyword_id.must_equal(@updated_attributes[:pickup_keyword_id])
      end
    end
  end

  describe ".non_pickup_tweet?" do
    PickupTweet::BOT_KEYWORDS.each do |keyword|
      before do
        @attrs = {
          id: 987654321,
          text: "てきすとてきすと",
          user:
          {
            id: 123456789,
            name: "test_user_name",
            screen_name:"test_user_screen_name"
          }
        }
      end

      describe ".bot_tweet?" do
        [:name, :screen_name].each do |attribute_name|
          context "#{attribute_name}に#{keyword}が含まれているとき" do
            before do
              @attrs[:user][attribute_name] = "aa#{keyword}bb"
              @tweet = Twitter::Tweet.new(@attrs)
            end

            it "trueであること" do
              PickupTweet.non_pickup_tweet?(@tweet).must_equal true
            end
          end

          context "screen_name, nameに#{keyword}が含まれていないとき" do
            before do
              @tweet = Twitter::Tweet.new(@attrs)
            end

            it "falseであること" do
              PickupTweet.non_pickup_tweet?(@tweet).must_equal false
            end
          end
        end
      end

      describe ".excluded_twitter_user_tweet?" do
        before do
          @excluded_twitter_user = create(:excluded_twitter_user)
        end

        context "excluded_twitter_userのuidと等しいツイートのとき" do
          before do
            @attrs[:user][:id] = @excluded_twitter_user.uid
            @tweet = Twitter::Tweet.new(@attrs)
          end

          it "trueであること" do
            PickupTweet.non_pickup_tweet?(@tweet).must_equal true
          end
        end

        context "excluded_twitter_userのuidと等しくないツイートのとき" do
          before do
            @tweet = Twitter::Tweet.new(@attrs)
          end

          it "falseであること" do
            PickupTweet.non_pickup_tweet?(@tweet).must_equal false
          end
        end 
      end
    end
  end
end
