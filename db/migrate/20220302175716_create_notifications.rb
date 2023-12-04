class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :message
      t.string :status
      t.integer :user_id
      t.string :title, limit: 255
      t.text :abc, limit: 65535
      t.timestamps
    end
    add_index :notifications, :user_id
  end
end
