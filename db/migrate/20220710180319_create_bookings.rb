class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.date :date
      t.boolean :is_premium
      t.integer :user_id
      t.boolean :is_international
      t.date :booking_date
      t.integer :booking_id
      t.timestamps
    end
    add_index :bookings, :user_id
    add_index :bookings, :booking_id
  end
end
