FactoryGirl.define do
  factory :supplier, :class => Spree::Supplier do
    name 'Acme Corporation'
    email 'acme@example.com'
    phone '1800 ACME CORP'
    website 'www.example.com'
  end
end
