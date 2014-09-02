class CreatePickupKeywords < ActiveRecord::Migration
  def change
    create_table :pickup_keywords do |t|
      t.string :pickup_keyword

      t.timestamps
    end
  end
end
