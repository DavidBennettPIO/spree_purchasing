module Spree
  module Admin
    class PurchaseOrdersController < ResourceController
      
      def build_resource
        purchase_order = PurchaseOrder.new(:ordered_on => Date.today)
        unless params[:purchase_order].nil?

          #purchase_order.supplier_id = params[:purchase_order][:supplier_id]
          
          purchase_order.assign_attributes(params[:purchase_order])
          
          #render :text => params[:purchase_order][:purchase_order_lines].to_s
          #params[:purchase_order][:purchase_order_lines].values.each do |pol|
          #  purchase_order.purchase_order_lines << PurchaseOrderLine.new(pol)
          #end
          #purchase_order
        end
        
        purchase_order
      end
      
    end
  end
end
