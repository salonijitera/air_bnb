class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.date :date
      t.boolean :is_premium
      t.integer :user_id
      t.boolean :is_international
      t.date :booking_date
      t.timestamps
    end
    add_index :bookings, :user_id
  end
end
