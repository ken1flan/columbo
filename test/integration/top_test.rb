require 'test_helper'

describe 'トップページ Integration' do
  before do
    create_list(:pickup_tweet, 10)
    @target = create(:pickup_tweet)
    visit root_path
  end

  it 'ツイートが表示されていること' do
    page.text.must_include(@target.text)
  end

  context 'ログインしているとき' do
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
      it 'スターの横の数値が1になること' do
        find(:css, "#like_pickup_tweet_#{@target.id}").click
        find(:css, "#like_pickup_tweet_#{@target.id}").text.must_include("1")
      end
    end
  end

  context 'ログインしているとき' do
    context 'スターを押したとき' do
      it 'スターが黒くなること' do
        skip
      end

      it 'スターの横の数値が1になること' do
        skip
      end
    end
  end
end
