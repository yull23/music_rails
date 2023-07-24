class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :total,null:false
      t.date :order_date,null:false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
