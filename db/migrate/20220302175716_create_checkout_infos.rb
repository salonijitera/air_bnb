class CreateCheckoutInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :checkout_infos do |t|
      t.float :total_amount
      t.date :checkout_date
      t.string :status
      t.timestamps
    end
  end
end
