require 'spec_helper'

describe "spree/suppliers/new" do
  before(:each) do
    assign(:spree_supplier, stub_model(Spree::Supplier).as_new_record)
  end

  it "renders new spree_supplier form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", spree_suppliers_path, "post" do
    end
  end
end
