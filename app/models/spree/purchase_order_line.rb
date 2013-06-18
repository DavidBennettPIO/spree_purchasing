module Spree
  class PurchaseOrderLine < ActiveRecord::Base
    
    attr_accessible :purchase_order, :order, :variant, :order_id, :variant_id, :price, :quantity
    
    belongs_to :purchase_order
    
    belongs_to :variant
    belongs_to :order # optinal so we know who this was for
    
    # These are only for hinting, there might not be any.
    has_many  :inventory_units
    
    before_save :link_inventory_units
    
    state_machine :initial => :pending do

      state :pending,     :value => 0
      state :ordered,     :value => 1
      #partially_received
      state :receiving,   :value => 2
      state :received,    :value => 3
      state :canceled,    :value => 15
      
      event :order_line do
        transition :pending => :ordered
      end

      event :receive do
        transition [:ordered, :receiving] => :received, :if => :fully_received?
        transition [:ordered, :receiving] => :receiving
      end

      event :cancel do
        transition :received => :ordered
      end

      after_transition :to => :received, :do => :receive_purchase_order

      after_transition :on => :cancel, :do => :unstock_variant

    end
    
    # overrides the event
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
    
    def as_json
      {
        :id => self.id,
        :state => self.state_name,
        :quantity => self.quantity,
        :quantity_received => self.quantity_received
      }
    end

    
    private
    
      def fully_received?
        self.quantity_received >= self.quantity
      end
    
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
      
      def unstock_variant
        # TODO
      end
    
      def link_inventory_units
        
        # Reset inventory_units
        self.inventory_units.each do |inventory_unit|
          inventory_unit.purchase_order_line_id = nil
          inventory_unit.save
        end
        
        # Add inventory_units, preferably from the order we added them from    
        if self.order.nil?
          assoc = Spree::InventoryUnit.where(:variant_id => self.variant.id, :purchase_order_line_id => nil).order(:id).limit(self.quantity)
        else
          assoc = Spree::InventoryUnit.where(:variant_id => self.variant.id, :purchase_order_line_id => nil).order('order_id = ? desc, id asc', self.order.id).limit(self.quantity)
        end
        
      end
      
      def receive_purchase_order
        self.purchase_order.receive
      end
  
  end
end
