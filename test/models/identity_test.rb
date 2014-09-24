# == Schema Information
#
# Table name: identities
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string(255)
#  uid        :string(255)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_identities_on_user_id  (user_id)
#

require 'test_helper'

describe Identity do
  describe '.find_for_oauth(auth)' do
    providers = [:twitter, :facebook]

    before do
      @users = {}
      @identities = {}
      providers.each do |provider|
        @users[provider] = create(:user)
        @identities[provider] = create(:identity, user_id: @users[provider].id, provider: "#{provider}", uid: "#{provider}_1")
      end
    end

    providers.each do |provider|
      context "存在する#{provider}ユーザを指定したとき" do
        it 'identityを返すこと' do
          auth = OmniAuth::AuthHash.new( provider: provider, uid: @identities[provider].uid )
          identity = Identity.find_for_oauth(auth)
          identity.user_id.must_equal(@users[provider].id)
          identity.provider.must_equal(provider.to_s)
          identity.uid.must_equal(@identities[provider].uid)
        end
      end

      context "存在しない#{provider}ユーザを指定したとき" do
        it 'identityを返すこと' do
          auth = OmniAuth::AuthHash.new( provider: provider, uid: @identities[provider].uid + "_not_exist" )
          identity = Identity.find_for_oauth(auth)
          identity.user_id.must_be_nil
          identity.provider.must_equal(provider)
          identity.uid.must_equal(auth.uid)
        end
      end
    end
  end
end
