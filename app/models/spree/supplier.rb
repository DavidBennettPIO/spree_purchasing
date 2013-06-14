module Spree
  class Supplier < ActiveRecord::Base
    
    has_many :products
    has_many :variants, :through => :products
    
    attr_accessible :email, :name, :phone, :website
    
    # DateTime.new(2013,5,20)
    
    def inventory_units
      Spree::InventoryUnit.backordered.where(:variant_id => self.variants.pluck(:id))
    end
    
    def posible_purchase_order_lines
      Spree::InventoryUnit.backordered.select('order_id, variant_id, count(*) as quantity').where(:variant_id => variant_ids).group(:order_id, :variant_id)
    end
    
    private
    
      def product_ids
        self.products.pluck(:id)
      end
      
      def variant_ids
        self.variants.pluck(:id)
      end
      
      def inventory_unit_ids
        Spree::InventoryUnit.select(:id).backordered.where(:variant_id => variant_ids).map{|iu|iu.id}
      end
    
  end
end
