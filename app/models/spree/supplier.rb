module Spree
  class Supplier < ActiveRecord::Base
    
    has_many :products
    has_many :variants, :through => :products
    
    has_many :purchase_orders
    has_many :purchase_order_lines, :through => :purchase_orders
    has_many :inventory_units, :through => :purchase_order_lines
    
    attr_accessible :email, :name, :phone, :website
    
    # DateTime.new(2013,5,20)
    
    
    def posible_purchase_order_lines
      # Spree::InventoryUnit.backordered.select('order_id, variant_id, count(*) as quantity').where(:variant_id => variant_ids).group(:order_id, :variant_id)
      Spree::InventoryUnit.backordered.select('order_id, variant_id, count(*) as quantity').where('id NOT IN (?) AND variant_id IN (?)', inventory_unit_ids, variant_ids).group(:order_id, :variant_id)
      #Spree::InventoryUnit.backordered.select('order_id, variant_id, count(*) as quantity').where('id NOT IN (NULL)').group(:order_id, :variant_id)
    end
    
    
    
    private
    
      def product_ids
        self.products.pluck(:id)
      end
      
      def variant_ids
        self.variants.pluck(:id)
      end
      
      def inventory_unit_ids
        ids = self.inventory_units.pluck(:id)
        (ids.size == 0)? [0] : ids
      end
    
  end
end
