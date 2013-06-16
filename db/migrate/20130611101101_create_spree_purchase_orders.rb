class CreateSpreePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :spree_purchase_orders do |t|
      # indexed
      t.references :supplier,   :null => false
      t.integer    :state,      :null => false, :default => 0, :limit => 2
      # fixed-length
      t.decimal    :total,      :null => false, :default => 0.0, :precision => 8, :scale => 2
      t.date       :ordered_on
      t.date       :arrives_on
      t.timestamps
      # var-length
      t.string     :number
      t.string     :invoice_number
      t.string     :tracking
      t.string     :notes
    end
    add_index  :spree_purchase_orders, [:state], :name => 'index_purchase_orders_on_state'
  end
end
