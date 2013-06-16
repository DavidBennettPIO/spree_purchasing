module Spree
  class PurchaseOrderLine < ActiveRecord::Base
    
    attr_accessible :purchase_order, :order, :variant, :order_id, :variant_id, :price, :quantity
    
    belongs_to :purchase_order
    
    belongs_to :variant
    belongs_to :order # optinal so we know who this was for
    
    has_many  :inventory_units
    
    state_machine :initial => :pending do

      state :pending,             :value => 0
      state :ordered,             :value => 1
      state :partially_received,  :value => 2
      state :received,            :value => 3
      state :canceled,            :value => 15

      event :receive do
        transition [:ordered, :partially_received] => :received, :if => :fully_received?
        transition [:ordered, :partially_received] => :partially_received
      end
      event :cancel do
        transition :received => :ordered
      end
      
      after_transition :to => :received, :do => :receive_purchase_order
  
      after_transition :on => :cancel, :do => :unstock_variant
      
    end
    
    # overrides the event - and not so safe for variant?
    def receive quantity_to_receive
      
      return unless self.can_receive?
      
      # no need to do anything      
      return if quantity_to_receive < 1
      
      # .limit(quantity_to_receive)
      backordered_units = self.inventory_units.with_state('backordered').slice(0, quantity_to_receive)

      receive_quietly backordered_units
      receive_loudly quantity_to_receive - backordered_units.count
      
      self.quantity_received += quantity_to_receive
      
      super
      
    end

    
    private
    
      # recive the backordered_units we know about first - not so safe for variant?
      def receive_quietly backordered_units
        
        return if backordered_units.count < 1
  
        # TODO backordered units are not in stock
  
        self.variant.update_column(:count_on_hand, self.variant.on_hand + backordered_units.count)
        self.variant.save
        backordered_units.each(&:fill_backorder)
  
      end
      
      # add the remainder the variant stock
      def receive_loudly quantity_to_receive
        
        return if quantity_to_receive < 1
  
        new_level = quantity_to_receive
          
        if self.variant.on_hand > 0
          new_level += self.variant.on_hand
        end
        
        self.variant.on_hand = new_level
        self.variant.save
  
      end
    
      def fully_received?
        self.quantity_received >= self.quantity
      end
      
      def unstock_variant
        # TODO
      end
      
      def receive_purchase_order
        self.purchase_order.receive
      end
  
  end
end
