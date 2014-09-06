class PickupTweetsPerDay < ActiveRecord::Base
  def self.take_statistics(pickup_keyword)
    create(target_date: Date.today, pickup_keyword_id: pickup_keyword.id, total: 0)
  end
end
