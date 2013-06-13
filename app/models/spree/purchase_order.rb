module Spree
  class PurchaseOrder < ActiveRecord::Base
    
    attr_accessible :supplier_id, :total, :ordered_on, :arrives_on, :state, :invoice_number, :tracking_number, :notes
    
    state_machine :initial => 'ordered' do

      event :receive do
        transition :from => 'ordered', :to => 'received'
      end
      event :cancel_receive do
        transition :from => 'received', :to => 'ordered'
      end
      
      after_transition :to => 'received', :do => :stock_variant
  
      after_transition :on => :cancel_receive, :do => :unstock_variant
    end
    
  end
end
