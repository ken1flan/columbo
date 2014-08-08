require 'test_helper'

describe 'トップページ Integration' do
  before do
    create_list(:pickup_tweet, 10)
    @target = create(:pickup_tweet)
    visit root_path
  end

  it 'ツイートが表示されていること' do
    @page.text.must_include(@target.
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
