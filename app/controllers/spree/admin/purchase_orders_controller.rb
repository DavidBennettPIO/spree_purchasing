module Spree
  module Admin
    class PurchaseOrdersController < ResourceController
      
      def build_resource
        purchase_order = PurchaseOrder.new(:ordered_on => Date.today)
        unless params[:purchase_order].nil?
          purchase_order.supplier_id = params[:purchase_order][:supplier_id]
        end
        purchase_order
      end
      
    end
  end
end
