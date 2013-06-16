module Spree
  module Admin
    class PurchaseOrderLinesController < Spree::Admin::BaseController
      
      def destroy
        purchase_order_line = Spree::PurchaseOrderLine.find(params[:id])
        purchase_order_line.destroy
        render :text => nil
      end
      
    end
  end
end
