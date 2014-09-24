# == Schema Information
#
# Table name: excluded_twitter_users
#
#  id          :integer          not null, primary key
#  uid         :string(255)
#  name        :string(255)
#  screen_name :string(255)
#  memo        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

FactoryGirl.define do
  factory :excluded_twitter_user do
    uid { rand(10000000).to_s }
    name { "name_#{rand(100)}" }
    screen_name { "screen_name_#{rand(100)}" }
    memo { "めもめも#{rand(100)}" }
  end
end
