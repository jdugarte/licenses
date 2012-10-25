require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "should not have empty name email password" do
    user = User.new 
    user.distributor_id = 1
    assert user.invalid?, "invalid?"
    assert user.errors[:name].any?, "name"
    assert user.errors[:email].any?, "email"
    assert user.errors[:password].any?, "password"
    assert !user.save
  end

end
