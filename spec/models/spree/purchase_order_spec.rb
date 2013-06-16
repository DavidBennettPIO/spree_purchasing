require 'spec_helper'

describe Spree::PurchaseOrder do
  
  before :each do
    
  end
  
  context "states" do
    
    let(:purchase_order) { create(:purchase_order) }
    let(:purchase_order_line) { create(:purchase_order_line, :purchase_order => purchase_order) }
    let(:purchase_order_line_received) { create(:purchase_order_line, :purchase_order => purchase_order, :state => 3) }
    
    
    
    context "pending" do

      it "should be an initial state" do
        purchase_order.should be_pending
      end
  
    end
    
    context "order" do
      
      it "should not be an initial state" do
        purchase_order.should_not be_ordered
      end

      it "should not be ordered with no lines" do
        purchase_order.order
        purchase_order.should_not be_ordered
      end
        
      it "should be ordered with one line" do
        purchase_order.purchase_order_lines.stub(:all).and_return([purchase_order_line])
        purchase_order.order!
        purchase_order.should be_ordered
      end
  
    end
   
    context "receive" do
      
      before :each do
        purchase_order.state = 1
      end

      it "should not be received with no lines" do
        purchase_order.receive
        purchase_order.should_not be_received
      end
      
      it "should not be received with one non-received line" do
        purchase_order.purchase_order_lines.stub(:all).and_return([purchase_order_line])
        purchase_order.receive
        purchase_order.should_not be_received
      end
      
      it "should be received with received lines" do
        purchase_order.purchase_order_lines.stub(:all).and_return([purchase_order_line_received, purchase_order_line_received])
        purchase_order.receive!
        purchase_order.should be_received
      end
      
      it "should be partially_received with mixed lines" do
        purchase_order.purchase_order_lines.stub(:all).and_return([purchase_order_line, purchase_order_line_received])
        purchase_order.receive!
        purchase_order.should be_partially_received
      end
      
      it "should change from partially_received to received" do
        purchase_order.purchase_order_lines.stub(:all).and_return([purchase_order_line, purchase_order_line_received])
        purchase_order.receive!
        purchase_order.should be_partially_received
        purchase_order.purchase_order_lines.stub(:all).and_return([purchase_order_line_received, purchase_order_line_received])
        purchase_order.receive!
        purchase_order.should be_received
      end
     
    end
    
  end
  
  
 
end
