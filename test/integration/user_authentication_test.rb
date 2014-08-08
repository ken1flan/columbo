require 'test_helper'

describe 'ユーザ認証 Integration' do
  before do
    OmniAuth.config.test_mode = true
    create_list(:pickup_tweet, 10)
  end

  describe 'twitterログイン' do
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
    end

    context 'トップページ上部のtwitterログインをクリックしたとき' do
      before do
        visit root_path
        click_link 'twitterログイン'
      end

      it 'ニックネームが表示されること' do
        page.text.must_include('twitter_user_name')
      end

      context 'ログアウトを押したとき' do
        before do
          click_link 'ログアウト'
        end

        it '各ログインボタンが表示されること' do
          page.text.must_include('twitterログイン')
          page.text.must_include('facebookログイン')
        end
      end
    end
  end

  describe 'facebookログイン' do
    before do
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        provider: 'facebook',
        uid: 'facebook_uid',
        extra: {
          raw_info: {
            name: 'facebook_user_name'
          }
        }
      })
    end

    context 'トップページ上部のfacebookログインをクリックしたとき' do
      before do
        visit root_path
        click_link 'facebookログイン'
      end

      it 'ニックネームが表示されること' do
        page.text.must_include('facebook_user_name')
      end

      context 'ログアウトを押したとき' do
        before do
          click_link 'ログアウト'
        end

        it '各ログインボタンが表示されること' do
          page.text.must_include('twitterログイン')
          page.text.must_include('facebookログイン')
        end
      end
    end
  end
end
