module Spree
  class PurchaseOrder < ActiveRecord::Base
    
    attr_accessible :supplier_id, :purchase_order_lines_attributes, :total, :ordered_on, :arrives_on, :state, :invoice_number, :tracking_number, :notes
    
    belongs_to :supplier
    
    has_many :purchase_order_lines
    accepts_nested_attributes_for :purchase_order_lines
    
    state_machine :initial => 'ordered' do

    end
    
  end
end
