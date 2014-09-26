# == Schema Information
#
# Table name: pickup_keywords
#
#  id             :integer          not null, primary key
#  pickup_keyword :string(255)
#  slug           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

class PickupKeywordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
