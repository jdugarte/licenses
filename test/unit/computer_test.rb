require 'test_helper'

class ComputerTest < ActiveSupport::TestCase

  test "should not have empty name" do
    computer = Computer.new 
    assert computer.invalid?, "invalid?"
    assert computer.errors[:name].any?, "name"
    assert !computer.save
  end

end
