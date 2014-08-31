require 'test_helper'

describe 'トップページ Integration' do
  before do
    @pickup_tweets = create_list(:pickup_tweet, 10)
    @target = create(:pickup_tweet)
    visit root_path
  end

  it 'ツイートが表示されていること' do
    page.text.must_include(@target.text)
  end

  context '一般ユーザでログインしているとき' do
    before do
      OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
        provider: 'twitter',
        uid: 'twitter_uid',
        extra: {
          raw_info: {
            name: 'twitter_user_name'
          }
        }
      })

      visit root_path
      click_link 'twitterログイン'
    end

    context 'スターを押したとき' do
      before do
        find(:css, "#like_pickup_tweet_#{@target.id}").click
        sleep 1
      end

      it 'スターの横の数値が1になること' do
        find(:css, "#like_pickup_tweet_#{@target.id}").text.must_include("1")
      end

      context 'もう一度スターを押したとき' do
        it 'スターの横の数値が0になること' do
          find(:css, "#like_pickup_tweet_#{@target.id}").click
          sleep 1
          find(:css, "#like_pickup_tweet_#{@target.id}").text.must_include("0")
        end
      end
    end
  end

  context 'ログインしていないとき' do
    context 'スターを押したとき' do
      it 'スターの横の数値が0のままであること' do
        find(:css, "#like_pickup_tweet_#{@target.id}").click
        sleep 1
        find(:css, "#like_pickup_tweet_#{@target.id}").text.must_include("0")
      end
    end
  end

  context "管理者ユーザでログインしているとき" do
    before do
      @user = create(:user, :admin)
      @identity = create(:identity, user_id: @user.id, provider: 'twitter')
      login('twitter', @identity.uid)
    end

    context "除外ツイッターユーザボタンを押したとき" do
      before do
        @pickup_tweet = @pickup_tweets.sample
        find(".button_create_excluded_twitter_user_#{@pickup_tweet.tweet_user_uid}").click
      end

      it "除外Twitter管理ページに名前があること" do
        visit admin_excluded_twitter_users_path
        sleep 1
        page.text.must_include @pickup_tweet.tweet_user_uid
        page.text.must_include @pickup_tweet.tweet_user_name
      end

      context "解除ボタンを押したとき" do
        before do
          find(".button_destroy_excluded_twitter_user_#{@pickup_tweet.tweet_user_uid}").click
        end

        it "除外Twitter管理ページに名前がないこと" do
          visit admin_excluded_twitter_users_path
          sleep 1
          page.text.wont_include @pickup_tweet.tweet_user_uid
          page.text.wont_include @pickup_tweet.tweet_user_name
        end
      end
    end
  end
end
