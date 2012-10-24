require 'test_helper'

class DistributorTest < ActiveSupport::TestCase

  test "should not have empty name" do
    dist = Distributor.new 
    dist.distributor_id = 1
    assert dist.invalid? 
    assert dist.errors[:name].any?
    assert !dist.save
  end

  test "must have a distributor parent" do
    dist = Distributor.new :name => "Distributor"
    assert dist.invalid?
    assert !dist.save
  end
  
  test "must have a distributor parent unless main?" do
    dist = Distributor.new :name => "Distributor", :main => true
    assert !dist.invalid?
    assert dist.save
  end
  
end
