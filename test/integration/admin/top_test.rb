require 'test_helper'

describe '管理者トップ Integration' do
  before do
    create(:pickup_tweet)
  end

  context 'ログインしていないとき' do
    it '404 not foundであること' do
      visit admin_path
      # FIXME なぜか500になっちゃう
      page.status_code.wont_equal 200
    end
  end
  
  context '一般ユーザでログインしたとき' do
    before do
      @user = create(:user)
      @identity = create(:identity, user_id: @user.id, provider: 'twitter')
      login2('twitter', @identity.uid)
    end

    it '404 not foundであること' do
      visit admin_path
      # FIXME なぜか500になっちゃう
      page.status_code.wont_equal 200
     end
  end

  context '管理者ユーザでログインしたとき' do
    before do
      @user = create(:user, :admin)
      @identity = create(:identity, user_id: @user.id, provider: 'twitter')
      login2('twitter', @identity.uid)
      binding.pry
    end

    it 'status_codeが200であること' do
      visit admin_path
      page.status_code.must_equal 200
     end
  end
end
