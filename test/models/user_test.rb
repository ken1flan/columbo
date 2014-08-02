require 'test_helper'

describe User do
  describe '.find_for_oauth' do
    context 'identityに未登録のauthのとき' do
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
        it 'authの情報が、identityとuserに登録されること' do
          user = User.find_for_oauth( @auth, nil )
          identity = Identity.find_by( uid: @auth.uid )

          user.name.must_equal(@auth.extra.raw_info.name)
          identity.provider.must_equal(@auth.provider)
          identity.uid.must_equal(@auth.uid)
          identity.user_id.must_equal(user.id)
        end
      end 

      context 'signed_in_resourceに登録されているuserが指定されているとき' do
        before do
          @user = create(:user)
          @user_count = User.count
        end

        it 'userは増えず、identityは登録されること' do
          user = User.find_for_oauth( @auth, @user )
          identity = Identity.find_by( uid: @auth.uid )

          User.count.must_equal(@user_count)
          user.must_equal(@user)
          identity.provider.must_equal(@auth.provider)
          identity.uid.must_equal(@auth.uid)
          identity.user_id.must_equal(user.id)
        end

      end
    end

    context 'userの紐付いているidentityをauthに指定しているとき' do
      before do
        @user = create(:user)
        @identity = create(:identity, user_id: @user.id)
        @auth = OmniAuth::AuthHash.new(
          provider: @identity.provider,
          uid: @identity.uid,
          extra: {
            raw_info: {
              name: 'test_name'
            }
          }
        )
        @user_count = User.count
        @identity_count = Identity.count
      end

      context 'signed_in_resourceがnilのとき' do
        it 'identity、userは登録されないこと' do
          user = User.find_for_oauth( @auth, nil )

          User.count.must_equal(@user_count)
          Identity.count.must_equal(@identity_count)
          user.must_equal(@user)
        end
      end
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
