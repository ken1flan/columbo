require 'test_helper'

describe User do
  describe '.find_for_oauth' do
    context 'authが未登録の情報のとき' do
      before do
        @auth = OmniAuth::AuthHash.new(
          provider: 'provider',
          uid: 'test_uid',
          extra: {
            raw_info: {
              name: 'test_name'
            }
          }
        )
      end

      context 'signed_in_resourceがnilのとき' do
        it '登録されること' do
          user = User.find_for_oauth( @auth, nil )
          identity = Identity.find_by( uid: @auth.uid )
        end
      end 
    end

    context 'ユーザの紐付いているidentityをauthに指定しているとき' do
    end

    context 'ユーザの紐付いていないidentityをauthに指定しているとき' do
    end

    context 'signed_in_resourceがauthで指定されているものと違うとき' do
      before do
        @signed_in_resource = create(:user)
      end
    end
  end
end
