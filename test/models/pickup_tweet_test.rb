require 'test_helper'

describe PickupTweet do
  describe 'default_scope' do
    context '1〜3日前のツイートが登録されているとき' do
      before do
        @tweet1 = create(:pickup_tweet, tweet_at: 1.day.ago)
        @tweet2 = create(:pickup_tweet, tweet_at: 2.day.ago)
        @tweet3 = create(:pickup_tweet, tweet_at: 3.day.ago)
        @tweets = PickupTweet.all
      end

      it 'ツイート時間が古い順に選択されること' do
        @tweets[0].id = @tweet3
        @tweets[1].id = @tweet2
        @tweets[2].id = @tweet1
      end
    end
  end

  describe '.can_display' do
    context '削除済みのツイートとそうでないツイートがあるとき' do
      before do
        @tweet = create(:pickup_tweet)
        @truncated_tweet = create(:pickup_tweet, :truncated)
        @tweets = PickupTweet.can_display
      end

      it '削除済みのツイートは選択されないこと' do
        @tweets.select{|t| t.id == @tweet.id}.present?.must_equal true
        @tweets.select{|t| t.id == @truncated_tweet.id}.blank?.must_equal true
      end
    end
  end

  describe '#is_liked_by?' do
  end

  describe '#like_number' do
  end

  describe '.get_tweets' do
  end

  describe '.housekeep' do
  end

  describe '.get_attributes_from_tweet(tweet, keyword)' do
    context 'tweetとkeywordが指定されているとき' do
      before do
        @tweet_attrs = {
          id: 100,
          text: 'tweet_text',
          tweet_at: 1.day.ago,
          truncated: false,
          user: {
            id: 200,
            name: 'tweet_user_name',
            screen_name: 'tweet_user_screen_name',
          }
        }
        @tweet = Twitter::Tweet.new(@tweet_attrs)
        @keyword = 'うちのカミさんが'

        @result = PickupTweet.get_attributes_from_tweet(@tweet, @keyword)
      end

      it 'tweet内容とkeywordが設定されていること' do
        @result[:attrs].must_equal(@tweet.attrs.to_s)
        @result[:tweet_id].must_equal(@tweet.id)
        @result[:text].must_equal(@tweet.text)
        @result[:truncated].must_equal(@tweet.truncated?)
        # TODO: profile_image_urlをどうやって指定するか調べる
        # @result[:tweet_user_image_url].must_equal(@tweet.user.profile_image_url)
        @result[:tweet_user_name].must_equal(@tweet.user.name)
        @result[:tweet_user_screen_name].must_equal(@tweet.user.screen_name)
        @result[:keyword].must_equal(@keyword)
      end
    end
  end

  describe '.create_or_update' do
    context 'DBに登録されていないtweet_idのとき' do
      it '正しく登録されていること' do
      end
    end

    context 'DBに登録されているtweet_idのとき' do
      it '正しく更新されていること' do
      end
    end
  end
end
