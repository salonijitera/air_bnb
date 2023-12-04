class CreateProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :properties do |t|
      t.string :name
      t.decimal :price
      t.string :location
      t.timestamps
    end
  end
end
