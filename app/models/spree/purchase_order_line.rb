class Spree::PurchaseOrderLine < ActiveRecord::Base
  attr_accessible :line_item, :price, :purchase_order, :quantity, :received, :variant
end
