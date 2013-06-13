module Spree
  class Supplier < ActiveRecord::Base
    
    has_many :products
    
    attr_accessible :email, :name, :phone, :website
    
    
    
    def inventory_units
      Spree::InventoryUnit.backordered.where('variant_id IN (?) AND created_at > ?', variant_ids, DateTime.new(2013,5,20))
    end
    
    private
    
      def product_ids
        self.products.select(:id).map{|p|p.id}
      end
      
      def variant_ids
        Spree::Variant.select(:id).where(:product_id => product_ids).map{|v|v.id}
      end
    
  end
end
