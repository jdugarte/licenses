require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "should not have empty name email" do
    user = User.new 
    user.distributor_id = 1
    assert user.invalid? 
    assert user.errors[:name].any?
    assert user.errors[:email].any?
    assert !user.save
  end

  test "must belong to a distributor" do
    user = User.new :name => "User", :email => "email@local.com"
    assert user.invalid?
    assert !user.save
  end
  
end
