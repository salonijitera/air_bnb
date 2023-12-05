class CreateLocalexperiences < ActiveRecord::Migration[5.2]
  def change
    create_table :localexperiences do |t|
      t.string :title
      t.text :description
      t.string :location
      t.decimal :price
      t.string :image
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
