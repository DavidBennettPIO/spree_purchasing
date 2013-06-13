require 'spec_helper'

describe Spree::PurchaseOrderLine do
  
  context "stock_variant" do
    let(:variant) { FactoryGirl.create(:variant, :on_demand => false) }
    let(:inventory_unit) { Spree::InventoryUnit.create({:state => "backordered", :variant => variant}, :without_protection => true) }
    let(:purchase_order_line) { Spree::PurchaseOrderLine.create({:state => "ordered", :variant => variant, :price => 12.34, :quantity => 1, :purchase_order_id => 1}, :without_protection => true) }

    context "when quantity is one" do
      
      
      before do
        purchase_order_line.quantity = 1
        Spree::Config.set :track_inventory_levels => true
      end

      it "should update on_hand for variant (no stock)" do
        purchase_order_line.variant.count_on_hand = 0
        purchase_order_line.variant.save!
        purchase_order_line.variant.should_receive(:on_hand=).with(1)
        purchase_order_line.variant.should_receive(:save)
        purchase_order_line.receive
      end
      
      it "should update on_hand for variant (has stock)" do
        purchase_order_line.variant.count_on_hand = 2
        purchase_order_line.variant.save!
        purchase_order_line.variant.should_receive(:on_hand=).with(3)
        purchase_order_line.variant.should_receive(:save)
        purchase_order_line.receive
      end
      
      it "should restock one backordered InventoryUnit (more then one IU)" do
        purchase_order_line.variant.count_on_hand = -5
        purchase_order_line.variant.save!
        variant.inventory_units.stub(:with_state).and_return(Array.new(5, inventory_unit))
        inventory_unit.should_receive(:fill_backorder).exactly(1).times
        purchase_order_line.receive
        purchase_order_line.variant.count_on_hand.should == -4
      end
      
      it "should restock one backordered InventoryUnit (only one IU)" do
        purchase_order_line.variant.count_on_hand = -1
        purchase_order_line.variant.save!
        variant.inventory_units.stub(:with_state).and_return(Array.new(1, inventory_unit))
        inventory_unit.should_receive(:fill_backorder).exactly(1).times
        purchase_order_line.receive
        purchase_order_line.variant.count_on_hand.should == 0
      end
      
      it "should add stock to variant (no stock)" do
        purchase_order_line.variant.count_on_hand = 0
        purchase_order_line.variant.save!
        variant.inventory_units.stub(:with_state).and_return(Array.new(0, inventory_unit))
        inventory_unit.should_receive(:fill_backorder).exactly(0).times
        purchase_order_line.receive
        purchase_order_line.variant.count_on_hand.should == 1
      end
      
      it "should add stock to variant (has stock)" do
        purchase_order_line.variant.count_on_hand = 1
        purchase_order_line.variant.save!
        variant.inventory_units.stub(:with_state).and_return(Array.new(0, inventory_unit))
        inventory_unit.should_receive(:fill_backorder).exactly(0).times
        purchase_order_line.receive
        purchase_order_line.variant.count_on_hand.should == 2
      end
    
    end
    
    context "when quantity is three" do
      
      
      before do
        purchase_order_line.quantity = 3
        Spree::Config.set :track_inventory_levels => true
      end

      it "should update on_hand for variant (no stock)" do
        purchase_order_line.variant.count_on_hand = 0
        purchase_order_line.variant.save!
        purchase_order_line.variant.should_receive(:on_hand=).with(3)
        purchase_order_line.variant.should_receive(:save)
        purchase_order_line.receive
      end
      
      it "should update on_hand for variant (has stock)" do
        purchase_order_line.variant.count_on_hand = 2
        purchase_order_line.variant.save!
        purchase_order_line.variant.should_receive(:on_hand=).with(5)
        purchase_order_line.variant.should_receive(:save)
        purchase_order_line.receive
      end
      
      it "should restock one backordered InventoryUnit (lots of IU's)" do
        purchase_order_line.variant.count_on_hand = -5
        purchase_order_line.variant.save!
        variant.inventory_units.stub(:with_state).and_return(Array.new(5, inventory_unit))
        inventory_unit.should_receive(:fill_backorder).exactly(3).times
        purchase_order_line.receive
        purchase_order_line.variant.count_on_hand.should == -2
      end
      
      it "should restock one backordered InventoryUnit (only one IU)" do
        purchase_order_line.variant.count_on_hand = -1
        purchase_order_line.variant.save!
        variant.inventory_units.stub(:with_state).and_return(Array.new(1, inventory_unit))
        inventory_unit.should_receive(:fill_backorder).exactly(1).times
        purchase_order_line.receive
        purchase_order_line.variant.count_on_hand.should == 2
      end
      
      it "should add stock to variant (no stock)" do
        purchase_order_line.variant.count_on_hand = 0
        purchase_order_line.variant.save!
        variant.inventory_units.stub(:with_state).and_return(Array.new(0, inventory_unit))
        inventory_unit.should_receive(:fill_backorder).exactly(0).times
        purchase_order_line.receive
        purchase_order_line.variant.count_on_hand.should == 3
      end
      
      it "should add stock to variant (has stock)" do
        purchase_order_line.variant.count_on_hand = 1
        purchase_order_line.variant.save!
        variant.inventory_units.stub(:with_state).and_return(Array.new(0, inventory_unit))
        inventory_unit.should_receive(:fill_backorder).exactly(0).times
        purchase_order_line.receive
        purchase_order_line.variant.count_on_hand.should == 4
      end
    
    end

  end


end
