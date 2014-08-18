def login(provider, uid)
  OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new({
    provider: provider,
    uid: uid,
    extra: {
      raw_info: {
        name: "#{provider}_user_name"
      }
    }
  })

  visit root_path
  click_link "#{provider}ログイン"
end
