require 'spec_helper'

describe "spree/suppliers/index" do
  before(:each) do
    assign(:spree_suppliers, [
      stub_model(Spree::Supplier),
      stub_model(Spree::Supplier)
    ])
  end

  it "renders a list of spree/suppliers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
