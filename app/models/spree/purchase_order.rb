module Spree
  class PurchaseOrder < ActiveRecord::Base
    
    attr_accessible :supplier_id, :purchase_order_lines_attributes, :total, :ordered_on, :arrives_on, :state, :number, :invoice_number, :tracking, :notes
    
    belongs_to :supplier
    
    has_many :purchase_order_lines
    accepts_nested_attributes_for :purchase_order_lines
    
    before_create :generate_purchase_order_number
    
    state_machine :initial => :pending do
      state :pending,             :value => 0
      state :ordered,             :value => 1
      state :partially_received,  :value => 2
      state :received,            :value => 3
      state :canceled,            :value => 15
      
      event :order do
        transition :pending => :ordered, :if => :has_lines?
      end

      event :receive do
        transition [:ordered, :partially_received] => :received, :if => :all_lines_received?
        transition [:ordered, :partially_received] => :partially_received, :if => :any_lines_received?
      end
      

    end
    
    private
    
      def has_lines?
        self.purchase_order_lines.count > 0
      end
      
      def all_lines_received?
        return false if self.purchase_order_lines.count < 1
        self.purchase_order_lines.all.map(&:received?).all?
      end
      
      def any_lines_received?
        return false if self.purchase_order_lines.count < 1
        (self.purchase_order_lines.all.map(&:received?).any? || self.purchase_order_lines.all.map(&:partially_received?).any?)
      end
      
      def generate_purchase_order_number
        record = true
        while record
          random = "P#{Array.new(7){rand(7)}.join}"
          record = self.class.where(:number => random).first
        end
        self.number = random if self.number.blank?
        self.number
      end
    
  end
end
