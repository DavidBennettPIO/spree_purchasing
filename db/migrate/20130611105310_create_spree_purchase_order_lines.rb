class CreateSpreePurchaseOrderLines < ActiveRecord::Migration
  def change
    create_table :spree_purchase_order_lines do |t|
      # indexed
      t.references :purchase_order,     :null => false
      t.references :variant,            :null => false
      t.references :order
      t.integer    :state,              :null => false, :default => 0, :limit => 2
      # fixed-length
      t.integer    :quantity,           :null => false
      t.integer    :quantity_received,  :null => false, :default => 0
      t.decimal    :price,              :null => false, :precision => 8, :scale => 2
      t.timestamps
      # var-length
    end
    add_index  :spree_purchase_order_lines, [:state], :name => 'index_purchase_order_lines_on_state'
  end
end
