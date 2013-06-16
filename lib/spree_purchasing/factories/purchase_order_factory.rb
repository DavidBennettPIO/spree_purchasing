FactoryGirl.define do
  factory :purchase_order, :class => Spree::PurchaseOrder do
    supplier { FactoryGirl.create(:supplier) }
    total 0
    ordered_on Date.yesterday
    arrives_on Date.today
    number '1234'
    invoice_number '5678'
    tracking 'SAO12345'
    
    #state 'pending'
  end
end
