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

class ExcludedTwitterUser < ActiveRecord::Base
end
