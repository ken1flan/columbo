require 'test_helper'

describe 'トップページ Integration' do
  before do
    create_list(:pickup_tweet, 10)
  end

  it 'test' do
    visit root_path
  end
end
