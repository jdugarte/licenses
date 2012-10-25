require 'test_helper'

class DistributorTest < ActiveSupport::TestCase

  test "should not have empty name" do
    dist = Distributor.new 
    assert dist.invalid? 
    assert dist.errors[:name].any?
    assert !dist.save
  end

  test "should have correct type" do
    assert_equal distributors(:logiciel).type, Distributor::MAIN
    assert distributors(:logiciel).main?
    assert_equal distributors(:master).type, Distributor::MASTER
    assert distributors(:master).master?
    assert_equal distributors(:dist1).type, Distributor::DISTRIBUTOR
    assert distributors(:dist1).dist?
  end

end
