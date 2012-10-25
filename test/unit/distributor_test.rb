require 'test_helper'

class DistributorTest < ActiveSupport::TestCase

  test "should not have empty name" do
    dist = Distributor.new 
    assert dist.invalid? 
    assert dist.errors[:name].any?
    assert !dist.save
  end

end
