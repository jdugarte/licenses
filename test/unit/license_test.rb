require 'test_helper'

class LicenseTest < ActiveSupport::TestCase
  
  unless Licenses::Application.config.generate_dummy_licenses

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
    test "can create new license after removed" do
      license1 = licenses(:renew_one)
      license1.remove "CA03FF8E", users(:user1)
      license2 = License.new application: applications(:dummy), computer: computers(:renew_one), sitecode: "044D4C09", mid: "8F33-D6E7-C3A0-426B"
      assert license2.valid?, "valid?"
      assert license2.save
    end
    test "should have status" do
      assert licenses(:unprocessed1).unprocessed?
      assert licenses(:processed1).active?
      # assert licenses(:rejected).rejected?
      # assert licenses(:removed).removed?
    end
    test "License.active should include only active licenses" do
      active_licenses = License.active
      assert active_licenses.include?(licenses(:processed1))
      assert !active_licenses.include?(licenses(:unprocessed1))
    end
    test "License.unprocessed should include only unprocessed licenses" do
      unprocessed_licenses = License.unprocessed
      assert unprocessed_licenses.include?(licenses(:unprocessed1))
      assert !unprocessed_licenses.include?(licenses(:processed1))
    end
    
    # process
    test "should approve license" do
      license = licenses(:unprocessed1)
      assert_nothing_raised License::AlreadyProcessed do
        license.approve!
      end
      assert license.active?
    end
    test "should approve several licenses" do
      assert_equal 1, License.approve!([licenses(:unprocessed1).id])
      license = License.find licenses(:unprocessed1).id
      assert license.active?
    end
    test "should reject license" do
      license = licenses(:unprocessed1)
      assert_nothing_raised License::AlreadyProcessed do
        license.reject!
      end
      assert license.rejected?
    end
    test "should reject several licenses" do
      assert_equal 1, License.reject!([licenses(:unprocessed1).id])
      license = License.find licenses(:unprocessed1).id
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
      assert_difference('Movement.count') do
        license.renew "F4F21A80", "162C-7E8F-D4CF-4A13", users(:user1), "Update license"
      end
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
    test "should renew license with a difference in one ID code" do
      license = licenses(:renew_one)
      assert_difference('Movement.count') do
        license.renew "044D4C09", "8F33-D6E7-C3A0-426B", users(:user1), "Update license"
      end
      assert_equal "4C005669-8A726B99-2EFA705E-805420E4", license.activation_code, "activation_code"
    end
    test "should renew license with a difference in two ID codes" do
      license = licenses(:renew_two)
      assert_difference('Movement.count') do
        license.renew "2D2DE1E4", "D2A3-60ED-3518-68FE", users(:user1), "Update license"
      end
      assert_equal "39FB9217-C0BC6415-554909A9-91BAA844", license.activation_code, "activation_code"
    end
    test "should raise License::NotActive when renewing" do
      license = licenses(:unprocessed1)
      assert_raise License::NotActive do
        assert_no_difference('Movement.count') do
          license.renew "XXXXXXXX", "XXXX-XXXX-XXXX-XXXX", users(:user1)
        end
      end
    end
    
    # remove
    test "should remove license" do
      license = licenses(:logiciel)
      assert_difference('Movement.count') do
        license.remove "9D3FB81E", users(:user1), "Test removing"
      end
      assert license.removed?, "removed?"
      assert_equal "Test removing", license.removal_reason, "removal_reason"
      assert_equal users(:user1).id, license.user.id, "user"
    end
    test "should raise License::NotActive when removing" do
      license = licenses(:unprocessed1)
      assert_raise License::NotActive do
        assert_no_difference('Movement.count') do
          license.remove "XXXXXXXX", users(:user1)
        end
      end
    end
    test "should raise License::IncorrectRemovalCode when removing" do
      license = licenses(:logiciel)
      assert_raise License::IncorrectRemovalCode do
        assert_no_difference('Movement.count') do
          license.remove "XXXXXXXX", users(:user1)
        end
      end
    end
    
    # transfer
    test "should transfer license" do
      license = licenses(:transfer)
      assert_difference('Movement.count') do
        license.transfer computers(:transfer_dest), "341879DF", "B4CB6928", "97CC-881B-1395-FFB3", users(:user1), "Transfer license"
      end
      # license codes
      assert_equal "F6F60E8D-A2B916B2-DD33DA14-A3E25021", license.activation_code, "activation_code"
      assert_equal "F9899C57", license.removal_code, "removal_code"
      # license ID codes
      assert_equal computers(:transfer_dest).id, license.computer.id, "computer"
      assert_equal 337, license.motherboard_bios, "motherboard_bios"
      assert_equal 1,   license.cpu, "cpu"
      assert_equal 113, license.hard_drive, "hard_drive"
      # other info
      assert_equal "Transfer license", license.notes, "notes"
      assert_equal users(:user1).id, license.user.id, "user"
    end
    test "should raise License::NotActive when transfering" do
      license = licenses(:unprocessed1)
      assert_raise License::NotActive do
        assert_no_difference('Movement.count') do
          license.transfer computers(:transfer_dest), "341879DF", "B4CB6928", "97CC-881B-1395-FFB3", users(:user1), "Transfer license"
        end
      end
    end
    test "should raise License::IncorrectRemovalCode when transfering" do
      license = licenses(:transfer)
      assert_raise License::IncorrectRemovalCode do
        assert_no_difference('Movement.count') do
          license.transfer computers(:transfer_dest), "XXXXXXXX", "B4CB6928", "97CC-881B-1395-FFB3", users(:user1), "Transfer license"
        end
      end
    end
  
  end
  
  private
  
    def get_new_license
      { sitecode: "XXXX-XXXX-XXXX-XXXX", mid: "XXXXXXXX" }
    end
  
end
