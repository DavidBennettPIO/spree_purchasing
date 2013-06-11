require 'spec_helper'

describe "spree/suppliers/edit" do
  before(:each) do
    @spree_supplier = assign(:spree_supplier, stub_model(Spree::Supplier))
  end

  it "renders the edit spree_supplier form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", spree_supplier_path(@spree_supplier), "post" do
    end
  end
end
