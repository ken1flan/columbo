class CreatePickupKeywords < ActiveRecord::Migration
  def change
    create_table :pickup_keywords do |t|
      t.string :pickup_keyword
      t.string :slug

      t.timestamps
    end
  end
end
