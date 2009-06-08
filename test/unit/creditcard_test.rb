require 'test_helper'

class CreditcardTest < ActiveSupport::TestCase
  
  context "instance authorization success" do
    setup do 
      @creditcard = Factory.build(:creditcard, :checkout => Factory(:checkout))
      @creditcard.authorize(100)
    end
    should_change "CreditcardPayment.count", :by => 1
    should_change "CreditcardTxn.count", :by => 1
    should_not_change "Order.by_state('new').count"   
  end
  
  context "instance authorization failture" do
    setup do 
      @creditcard = Factory.build(:creditcard, :number => "4111111111111999", :checkout => Factory(:checkout))
      begin @creditcard.authorize(100) rescue Spree::GatewayError end
    end
    should_not_change "CreditcardPayment.count"
    should_not_change "CreditcardTxn.count"    
    should_not_change "Order.by_state('new').count"   
  end
end