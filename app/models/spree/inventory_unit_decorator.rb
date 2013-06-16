Spree::InventoryUnit.class_eval do
  
  belongs_to :purchase_order_line
  
  attr_accessible :purchase_order_line_id, :purchase_order_line
  
end