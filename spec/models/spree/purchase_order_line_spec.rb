require 'spec_helper'

describe Spree::PurchaseOrderLine do
  
  let(:variant) { FactoryGirl.create(:variant, :on_demand => false) }
  let(:purchase_order_line) { create(:purchase_order_line, :variant => variant) }
  let(:inventory_unit) { Spree::InventoryUnit.create({:state => "backordered", :variant => variant}, :without_protection => true) }
  let(:inventory_unit_joined) { Spree::InventoryUnit.create({:state => "backordered", :variant => variant, :purchase_order_line => purchase_order_line}, :without_protection => true) }
  
  before :each do
    inventory_unit.stub(:update_order).and_return(true)
    inventory_unit_joined.stub(:update_order).and_return(true)
    purchase_order_line.inventory_units.stub(:with_state).and_return([])
    variant.inventory_units.stub(:with_state).and_return([])
  end
  
  context "pending" do

    it "should be the initial state" do
      purchase_order_line.should be_pending
    end
    
    it "should not transition to received" do
      purchase_order_line.variant.should_not_receive(:on_hand=)
      purchase_order_line.receive 1
      purchase_order_line.should be_pending
    end

  end
  
  context "receive" do
    
    before :each do
      purchase_order_line.state = 1
    end
    
    context "transitions" do
    
      it "should do nothing with no stock" do
        purchase_order_line.variant.should_not_receive(:on_hand=)
        purchase_order_line.receive 0
        purchase_order_line.should be_ordered
      end
      
      it "should be received when recieving correct ammount" do
        purchase_order_line.variant.should_receive(:on_hand=)
        purchase_order_line.receive purchase_order_line.quantity
        purchase_order_line.should be_received
      end
      
      it "should be received when recieving more then correct ammount" do
        purchase_order_line.variant.should_receive(:on_hand=)
        purchase_order_line.receive purchase_order_line.quantity + 1
        purchase_order_line.should be_received
      end
      
      it "should be partially_received when recieving less then correct ammount" do
        purchase_order_line.variant.should_receive(:on_hand=)
        purchase_order_line.receive purchase_order_line.quantity - 1
        purchase_order_line.should be_partially_received
        purchase_order_line.can_receive?.should == true
      end
      
      it "should be received when recieving less then correct ammount and then the remainder" do
        purchase_order_line.variant.should_receive(:on_hand=).exactly(2).times
        purchase_order_line.receive purchase_order_line.quantity - 1
        purchase_order_line.should be_partially_received
        purchase_order_line.receive 1
        purchase_order_line.should be_received
      end
      
    end
    
    context "variants with no backorders" do
    
      it "should update on_hand for variant (no stock)" do
        purchase_order_line.quantity = 1
        purchase_order_line.variant.count_on_hand = 0
        purchase_order_line.variant.save!
        purchase_order_line.variant.should_receive(:on_hand=).with(1)
        purchase_order_line.variant.should_receive(:save)
        purchase_order_line.receive 1
      end
      
      it "should update on_hand for variant (has stock)" do
        purchase_order_line.variant.count_on_hand = 2
        purchase_order_line.variant.save!
        purchase_order_line.variant.should_receive(:on_hand=).with(3)
        purchase_order_line.variant.should_receive(:save)
        purchase_order_line.receive 1
      end
      
      it "should update on_hand for variant (no stock)" do
        purchase_order_line.variant.count_on_hand = 0
        purchase_order_line.variant.save!
        purchase_order_line.variant.should_receive(:on_hand=).with(3)
        purchase_order_line.variant.should_receive(:save)
        purchase_order_line.receive 3
      end
      
      it "should update on_hand for variant (has stock)" do
        purchase_order_line.variant.count_on_hand = 2
        purchase_order_line.variant.save!
        purchase_order_line.variant.should_receive(:on_hand=).with(5)
        purchase_order_line.variant.should_receive(:save)
        purchase_order_line.receive 3
      end
    
    end

    context "when quantity is one" do
      
      
      before do
        purchase_order_line.quantity = 1
        Spree::Config.set :track_inventory_levels => true
      end
      
      it "should restock one backordered InventoryUnit (more then one IU)" do
        purchase_order_line.variant.count_on_hand = -5
        purchase_order_line.variant.save!
        variant.inventory_units.stub(:with_state).and_return(Array.new(5, inventory_unit))
        inventory_unit.should_receive(:fill_backorder).exactly(1).times
        purchase_order_line.receive 1
        purchase_order_line.variant.count_on_hand.should == -4
      end
      
      it "should restock one backordered InventoryUnit (only one IU)" do
        purchase_order_line.variant.count_on_hand = -1
        purchase_order_line.variant.save!
        variant.inventory_units.stub(:with_state).and_return(Array.new(1, inventory_unit))
        inventory_unit.should_receive(:fill_backorder).exactly(1).times
        purchase_order_line.receive 1
        purchase_order_line.variant.count_on_hand.should == 0
      end
    
    end
    
    context "when quantity is three" do
      
      
      before do
        purchase_order_line.quantity = 3
        Spree::Config.set :track_inventory_levels => true
      end
      
      it "should restock three backordered InventoryUnit (lots of IU's)" do
        purchase_order_line.variant.count_on_hand = -5
        purchase_order_line.variant.save!
        variant.inventory_units.stub(:with_state).and_return(Array.new(5, inventory_unit))
        inventory_unit.should_receive(:fill_backorder).exactly(3).times
        purchase_order_line.receive 3
        purchase_order_line.variant.count_on_hand.should == -2
      end
      
      it "should restock one backordered InventoryUnit (only one IU)" do
        purchase_order_line.variant.count_on_hand = -1
        purchase_order_line.variant.save!
        variant.inventory_units.stub(:with_state).and_return(Array.new(1, inventory_unit))
        inventory_unit.should_receive(:fill_backorder).exactly(1).times
        purchase_order_line.receive 3
        purchase_order_line.variant.count_on_hand.should == 2
      end

    end
    
    context "joined backorders when quantity is three" do
      
      before do
        purchase_order_line.quantity = 3
        Spree::Config.set :track_inventory_levels => true
      end
      
      it "should restock three backordered InventoryUnit (lots of IU's)" do
        purchase_order_line.variant.count_on_hand = -5
        purchase_order_line.variant.save!
        
        inventory_units = Array.new(5, inventory_unit_joined)
        purchase_order_line.inventory_units.stub(:with_state).and_return(inventory_units)
        variant.inventory_units.stub(:with_state).and_return(inventory_units)
        
        purchase_order_line.variant.should_not_receive(:on_hand=)
        purchase_order_line.variant.should_receive(:save)
        
        inventory_unit_joined.should_receive(:fill_backorder).exactly(3).times
        purchase_order_line.receive 3
        purchase_order_line.variant.count_on_hand.should == -2
      end
      
      it "should restock one backordered InventoryUnit (only one IU)" do
        purchase_order_line.variant.count_on_hand = -1
        purchase_order_line.variant.save!
        
        inventory_units = Array.new(1, inventory_unit_joined)
        purchase_order_line.inventory_units.stub(:with_state).and_return(inventory_units)
        variant.inventory_units.stub(:with_state).and_return(inventory_units)
        
        #purchase_order_line.variant.should_receive(:on_hand=).with(2)
        purchase_order_line.variant.should_receive(:save).exactly(2).times

        inventory_unit_joined.should_receive(:fill_backorder).exactly(1).times
        purchase_order_line.receive 3
        purchase_order_line.variant.count_on_hand.should == 2
      end
    
    end

  end


end
