class CreateWishListItems < ActiveRecord::Migration[5.2]
  def change
    create_table :wish_list_items do |t|
      t.references :wish_list, foreign_key: true
      t.integer :max_items, null: false
      t.integer :min_items, null: false
      t.timestamps
    end
  end
end
