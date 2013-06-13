class CreateSpreePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :spree_purchase_orders do |t|
      t.references :supplier,       :null => false
      t.decimal    :total,          :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.date       :ordered_on
      t.date       :arrives_on
      t.string     :state
      t.string     :invoice_number
      t.string     :tracking_number
      t.string     :notes

      t.timestamps
    end
  end
end
