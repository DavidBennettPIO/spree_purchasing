module Spree
  module Admin
    class PurchaseOrdersController < ResourceController
      
      new_action.before :assign_attrs
      
      def assign_attrs
        @object.ordered_on = Date.today
        @object.attributes = params[:purchase_order]
      end
      
      def location_after_save
        object_url @object
      end
      
      def order
        @object.order
        redirect_to location_after_save
      end
      
    end
  end
end
