class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :location
      t.boolean :is_vip, default: false
      t.timestamps
    end
  end
end
class AddRelationsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :wish_lists, :user, foreign_key: true
    add_reference :notifications, :user, foreign_key: true
    add_reference :premium_listings, :user, foreign_key: true
    add_reference :bookings, :user, foreign_key: true
  end
end
