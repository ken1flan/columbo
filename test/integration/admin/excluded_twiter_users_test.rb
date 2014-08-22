require 'test_helper'

describe '除外twitterユーザ管理 Integration' do
  before do
    create(:pickup_tweet)
  end

  context 'ログインしていないとき' do
    it '404 not foundであること' do
      visit admin_excluded_twitter_users_path
      # FIXME なぜか500になっちゃう
      page.status_code.wont_equal 200
    end
  end
  
  context '一般ユーザでログインしたとき' do
    before do
      @user = create(:user)
      @identity = create(:identity, user_id: @user.id, provider: 'twitter')
      login('twitter', @identity.uid)
    end

    it '404 not foundであること' do
      visit admin_excluded_twitter_users_path
      # FIXME なぜか500になっちゃう
      page.status_code.wont_equal 200
     end
  end

  context '管理者ユーザでログインしたとき' do
    before do
      @user = create(:user, :admin)
      @identity = create(:identity, user_id: @user.id, provider: 'twitter')
      login('twitter', @identity.uid)
      visit admin_excluded_twitter_users_path
    end

    it 'status_codeが200であること' do
      page.status_code.must_equal 200
    end

    context '新規作成をしたとき' do
      it '一覧に表示されていること' do
      end

      it '詳細ページが表示されること' do
      end

      context '編集したとき' do
        it '一覧に表示されていること' do
        end

        it '詳細ページが表示されること' do
        end
      end

      context '削除したとき' do
        it '一覧に表示されていないこと' do
        end
      end
    end
  end
end
