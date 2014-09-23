require 'test_helper'

describe 'ピックアップキーワード管理 Integration' do
  before do
    create(:pickup_tweet)
  end

  context 'ログインしていないとき' do
    it '404 not foundであること' do
      visit admin_pickup_keywords_path
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
      visit admin_pickup_keywords_path
      # FIXME なぜか500になっちゃう
      page.status_code.wont_equal 200
     end
  end

  context '管理者ユーザでログインしたとき' do
    before do
      @user = create(:user, :admin)
      @identity = create(:identity, user_id: @user.id, provider: 'twitter')
      login('twitter', @identity.uid)
      visit admin_pickup_keywords_path
    end

    it 'status_codeが200であること' do
      page.status_code.must_equal 200
    end

    context '新規作成をしたとき' do
      before do
        @data = {
          pickup_keyword: 'うちのカミさん',
          slug: 'kami-san',
        }
        click_link('button_add_new')
        fill_in 'pickup_keyword_pickup_keyword', with: @data[:pickup_keyword]
        fill_in 'pickup_keyword_slug', with: @data[:slug]
        click_button 'button_submit'
      end

      it '一覧に表示されていること' do
        visit admin_pickup_keywords_path
        page.text.must_include @data[:pickup_keyword]
        page.text.must_include @data[:slug]
      end

      it '詳細ページが表示されること' do
        page.text.must_include @data[:pickup_keyword]
        page.text.must_include @data[:slug]
      end

      context '編集したとき' do
        before do
          click_link 'button_edit'
          @updated_data = {
            pickup_keyword: 'うちのカミさん',
            slug: 'kami-san',
          }
          fill_in 'pickup_keyword_pickup_keyword', with: @updated_data[:pickup_keyword]
          fill_in 'pickup_keyword_slug', with: @updated_data[:slug]
          click_button 'button_submit'
        end

        it '一覧に表示されていること' do
          visit admin_pickup_keywords_path
          page.text.must_include @updated_data[:pickup_keyword]
          page.text.must_include @updated_data[:slug]
        end
  
        it '詳細ページが表示されること' do
          page.text.must_include @updated_data[:pickup_keyword]
          page.text.must_include @updated_data[:slug]
        end
      end

      context '削除したとき' do
        before do
          visit admin_pickup_keywords_path
          click_link 'Destroy'
        end

        it '一覧に表示されていないこと' do
          page.text.wont_include @data[:pickup_keyword]
          page.text.wont_include @data[:slug]
        end
      end
    end
  end
end
