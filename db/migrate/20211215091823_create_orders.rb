class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders, id: :uuid do |t|
      t.date :due_date
      t.string :title
      t.float :amount
      t.string :seller_name
      t.string :buyer_name
      t.references :gig, null: true, foreign_key: true
      t.references :seller, null: false, foreign_key: {to_table: :users}
      t.references :buyer, null: false, foreign_key: {to_table: :users}
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
