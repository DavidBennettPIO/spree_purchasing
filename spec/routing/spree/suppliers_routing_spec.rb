require "spec_helper"

describe Spree::SuppliersController do
  describe "routing" do

    it "routes to #index" do
      get("/spree/suppliers").should route_to("spree/suppliers#index")
    end

    it "routes to #new" do
      get("/spree/suppliers/new").should route_to("spree/suppliers#new")
    end

    it "routes to #show" do
      get("/spree/suppliers/1").should route_to("spree/suppliers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/spree/suppliers/1/edit").should route_to("spree/suppliers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/spree/suppliers").should route_to("spree/suppliers#create")
    end

    it "routes to #update" do
      put("/spree/suppliers/1").should route_to("spree/suppliers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/spree/suppliers/1").should route_to("spree/suppliers#destroy", :id => "1")
    end

  end
end
