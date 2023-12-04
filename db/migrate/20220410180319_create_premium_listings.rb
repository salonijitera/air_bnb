class CreatePremiumListings < ActiveRecord::Migration[5.2]
  def change
    create_table :premium_listings do |t|
      t.string :listing_name
      t.string :listing_status
      t.string :title
      t.text :description
      t.decimal :price
      t.string :status
      t.date :posted_date
      t.integer :user_id
      t.date :listing_date
      t.timestamps
    end
    add_index :premium_listings, :user_id
  end
end
