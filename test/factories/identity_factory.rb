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

FactoryGirl.define do
  factory :identity do
    user_id nil
    provider 'twitter'
    uid { "#{rand(100000)}" }
  end

  trait :twitter do
    provider 'twitter'
  end

  trait :facebook do
    provider 'facebook'
  end
end
