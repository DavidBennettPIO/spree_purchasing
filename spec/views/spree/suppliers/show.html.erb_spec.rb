require 'spec_helper'

describe "spree/suppliers/show" do
  before(:each) do
    @spree_supplier = assign(:spree_supplier, stub_model(Spree::Supplier))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
