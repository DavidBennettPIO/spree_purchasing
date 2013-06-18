module Spree
  module Admin
    class PurchaseOrderLinesController < Spree::Admin::BaseController
      
      def receive
        purchase_order_line = Spree::PurchaseOrderLine.find(params[:id])
        purchase_order_line.receive params[:quantity].to_i
        render :json => {:purchase_order_line => purchase_order_line.as_json}, :root => false
      end

      def destroy
        purchase_order_line = Spree::PurchaseOrderLine.find(params[:id])
        purchase_order_line.destroy
        render :text => nil
      end

    end
  end
end
