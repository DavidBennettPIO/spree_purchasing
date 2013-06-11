require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe Spree::SuppliersController do

  # This should return the minimal set of attributes required to create a valid
  # Spree::Supplier. As you add validations to Spree::Supplier, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { {  } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Spree::SuppliersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all spree_suppliers as @spree_suppliers" do
      supplier = Spree::Supplier.create! valid_attributes
      get :index, {}, valid_session
      assigns(:spree_suppliers).should eq([supplier])
    end
  end

  describe "GET show" do
    it "assigns the requested spree_supplier as @spree_supplier" do
      supplier = Spree::Supplier.create! valid_attributes
      get :show, {:id => supplier.to_param}, valid_session
      assigns(:spree_supplier).should eq(supplier)
    end
  end

  describe "GET new" do
    it "assigns a new spree_supplier as @spree_supplier" do
      get :new, {}, valid_session
      assigns(:spree_supplier).should be_a_new(Spree::Supplier)
    end
  end

  describe "GET edit" do
    it "assigns the requested spree_supplier as @spree_supplier" do
      supplier = Spree::Supplier.create! valid_attributes
      get :edit, {:id => supplier.to_param}, valid_session
      assigns(:spree_supplier).should eq(supplier)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Spree::Supplier" do
        expect {
          post :create, {:spree_supplier => valid_attributes}, valid_session
        }.to change(Spree::Supplier, :count).by(1)
      end

      it "assigns a newly created spree_supplier as @spree_supplier" do
        post :create, {:spree_supplier => valid_attributes}, valid_session
        assigns(:spree_supplier).should be_a(Spree::Supplier)
        assigns(:spree_supplier).should be_persisted
      end

      it "redirects to the created spree_supplier" do
        post :create, {:spree_supplier => valid_attributes}, valid_session
        response.should redirect_to(Spree::Supplier.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved spree_supplier as @spree_supplier" do
        # Trigger the behavior that occurs when invalid params are submitted
        Spree::Supplier.any_instance.stub(:save).and_return(false)
        post :create, {:spree_supplier => {  }}, valid_session
        assigns(:spree_supplier).should be_a_new(Spree::Supplier)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Spree::Supplier.any_instance.stub(:save).and_return(false)
        post :create, {:spree_supplier => {  }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested spree_supplier" do
        supplier = Spree::Supplier.create! valid_attributes
        # Assuming there are no other spree_suppliers in the database, this
        # specifies that the Spree::Supplier created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Spree::Supplier.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => supplier.to_param, :spree_supplier => { "these" => "params" }}, valid_session
      end

      it "assigns the requested spree_supplier as @spree_supplier" do
        supplier = Spree::Supplier.create! valid_attributes
        put :update, {:id => supplier.to_param, :spree_supplier => valid_attributes}, valid_session
        assigns(:spree_supplier).should eq(supplier)
      end

      it "redirects to the spree_supplier" do
        supplier = Spree::Supplier.create! valid_attributes
        put :update, {:id => supplier.to_param, :spree_supplier => valid_attributes}, valid_session
        response.should redirect_to(supplier)
      end
    end

    describe "with invalid params" do
      it "assigns the spree_supplier as @spree_supplier" do
        supplier = Spree::Supplier.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Spree::Supplier.any_instance.stub(:save).and_return(false)
        put :update, {:id => supplier.to_param, :spree_supplier => {  }}, valid_session
        assigns(:spree_supplier).should eq(supplier)
      end

      it "re-renders the 'edit' template" do
        supplier = Spree::Supplier.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Spree::Supplier.any_instance.stub(:save).and_return(false)
        put :update, {:id => supplier.to_param, :spree_supplier => {  }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested spree_supplier" do
      supplier = Spree::Supplier.create! valid_attributes
      expect {
        delete :destroy, {:id => supplier.to_param}, valid_session
      }.to change(Spree::Supplier, :count).by(-1)
    end

    it "redirects to the spree_suppliers list" do
      supplier = Spree::Supplier.create! valid_attributes
      delete :destroy, {:id => supplier.to_param}, valid_session
      response.should redirect_to(spree_suppliers_url)
    end
  end

end
