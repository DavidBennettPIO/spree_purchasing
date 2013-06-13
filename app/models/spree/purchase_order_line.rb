module Spree
  class PurchaseOrderLine < ActiveRecord::Base
    
    attr_accessible :line_item, :purchase_order, :price, :quantity, :variant
    
    belongs_to :purchase_order
    
    belongs_to :variant
    belongs_to :order # optinal so we know who this was for
    
    state_machine :initial => 'ordered' do

      event :receive do
        transition :from => 'ordered', :to => 'received'
      end
      event :cancel do
        transition :from => 'received', :to => 'ordered'
      end
      
      after_transition :to => 'received', :do => :stock_variant
  
      after_transition :on => :cancel, :do => :unstock_variant
      
      after_transition :on => :fill_backorder, :do => :update_order
      
    end
    
    private
    
      def stock_variant
        
        new_level = self.quantity
        
        if variant.on_hand > 0
          new_level += variant.on_hand
        end
        
        variant.on_hand = new_level
        variant.save
        
      end
      
      def unstock_variant
        # TODO
      end
  
  end
end
