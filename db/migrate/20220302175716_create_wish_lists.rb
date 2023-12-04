class CreateWishLists < ActiveRecord::Migration[5.2]
  def change
    create_table :wish_lists do |t|
      t.string :name, null: false
      t.integer :max_wishlist
      t.references :user, foreign_key: true
      t.timestamps
    end
    add_index :wish_lists, :name, unique: true
  end
end
