class AddSupplierToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :supplier_id, :integer # , :null => false
    add_index  :spree_products, [:supplier_id], :name => 'index_spree_products_on_supplier_id'
  end
end
