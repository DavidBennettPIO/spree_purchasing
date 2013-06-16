FactoryGirl.define do
  factory :purchase_order_line, :class => Spree::PurchaseOrderLine do
    purchase_order { FactoryGirl.create(:purchase_order) }
    variant { FactoryGirl.create(:variant) }
    quantity 3
    price 12.34

    #state 'pending'
  end
end
