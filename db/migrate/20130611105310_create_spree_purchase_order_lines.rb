class CreateSpreePurchaseOrderLines < ActiveRecord::Migration
  def change
    create_table :spree_purchase_order_lines do |t|
      t.references :purchase_order,   :null => false
      t.references :variant,          :null => false
      t.references :line_item
      t.integer    :quantity,         :null => false
      t.decimal    :price,            :null => false, :precision => 8, :scale => 2
      t.boolean    :received,         :null => false, :default => false

      t.timestamps
    end
  end
end
