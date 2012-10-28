require 'test_helper'

class LicenseTest < ActiveSupport::TestCase

  test "should not have empty sitecode, mid" do
    license = License.new 
    assert license.invalid?, "invalid?"
    assert license.errors[:sitecode].any?, "sitecode"
    assert license.errors[:mid].any?, "mid"
    assert !license.save
  end

  test "should have default status of License::UNPROCESSED" do
    license = License.new sitecode: "X", mid: "X"
    assert_equal license.status, License::UNPROCESSED
  end

  test "should have only one license per computer and application" do
    license = License.new(get_new_license)
    license.application = applications(:accounting)
    license.computer = computers(:pc1)
    assert license.invalid?, "invalid?"
    assert license.errors[:computer_id].any?, "computer_id"
    assert !license.save
  end
  
  test "should have status" do
    assert licenses(:unprocessed1).unprocessed?
    assert licenses(:processed1).active?
  end

  test "should approve license" do
    license = licenses(:unprocessed1)
    assert_nothing_raised License::AlreadyProcessed do
      license.approve!
    end
    assert license.active?
  end

  test "should reject license" do
    license = licenses(:unprocessed1)
    assert_nothing_raised License::AlreadyProcessed do
      license.reject!
    end
    assert license.rejected?
  end

  test "should raise error when processing already processed license" do
    license = licenses(:processed1)
    
    assert_raise License::AlreadyProcessed do
      license.approve!
    end
    assert license.active?
    
    assert_raise License::AlreadyProcessed do
      license.reject!
    end
    assert license.active?
  end

  private
  
    def get_new_license
      { sitecode: "XXXX-XXXX-XXXX-XXXX", mid: "XXXXXXXX" }
    end
  
end
