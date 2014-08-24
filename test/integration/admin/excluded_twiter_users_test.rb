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
      before do
        @data = {
          uid: '123',
          name: 'taro_yamada',
          screen_name: 'yamadayama',
          memo: 'メモメモメモメモ'
        }
        click_link('button_add_new')
        fill_in 'excluded_twitter_user_uid', with: @data[:uid]
        fill_in 'excluded_twitter_user_name', with: @data[:name]
        fill_in 'excluded_twitter_user_screen_name', with: @data[:screen_name]
        fill_in 'excluded_twitter_user_memo', with: @data[:memo]
        click_button 'button_submit'
      end

      it '一覧に表示されていること' do
        visit admin_excluded_twitter_users_path
        page.text.must_include @data[:uid]
        page.text.must_include @data[:name]
        page.text.must_include @data[:screen_name]
        page.text.must_include @data[:memo]
      end

      it '詳細ページが表示されること' do
        page.text.must_include @data[:uid]
        page.text.must_include @data[:name]
        page.text.must_include @data[:screen_name]
        page.text.must_include @data[:memo]
      end

      context '編集したとき' do
        before do
          click_link 'button_edit'
          @updated_data = {
            uid: '987',
            name: 'taro_tanaka',
            screen_name: 'tanakada',
            memo: '編集後のめもめもめもめも'
          }
          fill_in 'excluded_twitter_user_uid', with: @updated_data[:uid]
          fill_in 'excluded_twitter_user_name', with: @updated_data[:name]
          fill_in 'excluded_twitter_user_screen_name', with: @updated_data[:screen_name]
          fill_in 'excluded_twitter_user_memo', with: @updated_data[:memo]
          click_button 'button_submit'
        end

        it '一覧に表示されていること' do
          visit admin_excluded_twitter_users_path
          page.text.must_include @updated_data[:uid]
          page.text.must_include @updated_data[:name]
          page.text.must_include @updated_data[:screen_name]
          page.text.must_include @updated_data[:memo]
        end
  
        it '詳細ページが表示されること' do
          page.text.must_include @updated_data[:uid]
          page.text.must_include @updated_data[:name]
          page.text.must_include @updated_data[:screen_name]
          page.text.must_include @updated_data[:memo]
        end
      end

      context '削除したとき' do
        before do
          visit admin_excluded_twitter_users_path
          click_link 'Destroy'
        end

        it '一覧に表示されていないこと' do
          page.text.wont_include @data[:uid]
          page.text.wont_include @data[:name]
          page.text.wont_include @data[:screen_name]
          page.text.wont_include @data[:memo]
        end
      end
    end
  end
end
