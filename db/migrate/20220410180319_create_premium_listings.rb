class CreatePremiumListings < ActiveRecord::Migration[5.2]
  def change
    create_table :premium_listings do |t|
      t.string :listing_name
      t.string :listing_status
      t.timestamps
    end
  end
end
