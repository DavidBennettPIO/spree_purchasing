class Spree::PurchaseOrder < ActiveRecord::Base
  attr_accessible :estimated_arrival, :invoice_number, :notes, :ordered_at, :state, :supplier, :total, :tracking_number
end
