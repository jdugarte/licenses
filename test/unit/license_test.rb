require 'test_helper'

class LicenseTest < ActiveSupport::TestCase
  
  # definition
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
  
  # process
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
  
  # renew
  test "should renew license" do
    license = licenses(:logiciel)
    license.renew "F4F21A80", "162C-7E8F-D4CF-4A13", users(:user1), "Update license"
    # license codes
    assert_equal "D677A8F6-109A1636-364E8B5D-1D0CA327", license.activation_code, "activation_code"
    assert_equal "061D40E5", license.removal_code, "removal_code"
    # license ID codes
    assert_equal 659, license.motherboard_bios, "motherboard_bios"
    assert_equal 19,  license.cpu, "cpu"
    assert_equal 125, license.hard_drive, "hard_drive"
    # other info
    assert_equal "Update license", license.notes, "notes"
    assert_equal users(:user1).id, license.user.id, "user"
    # computer ID codes
    computer = computers(:logiciel)
    assert_equal 659, computer.motherboard_bios, "motherboard_bios"
    assert_equal 19,  computer.cpu, "cpu"
    assert_equal 125, computer.hard_drive, "hard_drive"
  end
  test "should raise ArgumentError when renewing" do
    license = licenses(:processed1)
    assert_raise ArgumentError do
      license.renew
    end
  end
  test "should raise License::NotActive when renewing" do
    license = licenses(:unprocessed1)
    assert_raise License::NotActive do
      license.renew "XXXXXXXX", "XXXX-XXXX-XXXX-XXXX", users(:user1)
    end
  end
  
  # remove
  test "should remove license" do
    license = licenses(:logiciel)
    license.remove "9D3FB81E", users(:user1), "Test removing"
    assert license.removed?, "removed?"
    assert_equal "Test removing", license.removal_reason, "removal_reason"
    assert_equal users(:user1).id, license.user.id, "user"
  end
  test "should raise ArgumentError when removing" do
    license = licenses(:processed1)
    assert_raise ArgumentError do
      license.remove
    end
  end
  test "should raise License::NotActive when removing" do
    license = licenses(:unprocessed1)
    assert_raise License::NotActive do
      license.remove "XXXXXXXX", users(:user1)
    end
  end
  test "should raise License::IncorrectRemovalCode" do
    license = licenses(:logiciel)
    assert_raise License::IncorrectRemovalCode do
      license.remove "XXXXXXXX", users(:user1)
    end
  end
  
  private
  
    def get_new_license
      { sitecode: "XXXX-XXXX-XXXX-XXXX", mid: "XXXXXXXX" }
    end
  
end
