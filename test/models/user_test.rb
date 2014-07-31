require 'test_helper'

describe User do
  describe '.find_for_oauth' do
    context 'authが未登録の情報のとき' do
      context 'signed_in_resourceがnilのとき' do
        it '登録されること' do
        end
      end

      context 'signed_in_resourceがauthで指定されているものと違うとき' do
      end

      context 'signed_in_resourceがauthで指定されているものと同じとき' do
      end
    end

    context 'authが登録済の情報のとき' do
      context 'signed_in_resourceがnilのとき' do
      end

      context 'signed_in_resourceがauthで指定されているものと違うとき' do
      end

      context 'signed_in_resourceがauthで指定されているものと同じとき' do
      end
     end
  end
end
