class AddPurchaseOrderLineToInventoryUnits < ActiveRecord::Migration
  def change
    add_column :spree_inventory_units, :purchase_order_line_id, :integer
    add_index  :spree_inventory_units, [:purchase_order_line_id], :name => 'index_spree_inventory_units_on_supplier_id'
  end
end
