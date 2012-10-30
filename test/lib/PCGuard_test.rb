require 'test_helper'

class PCGuardTest < ActiveSupport::TestCase

  test "should generate codes" do
    dummy = licenses(:dummy)
    license = PCGuard.new dummy.application.ProgramID, dummy.sitecode, dummy.mid
    assert_equal "5A87C3E1-DC9B06E0-C9EB8734-B9485F7A", license.activation_code, "activation_code"
    assert_equal "0B05E0CB", license.removal_code, "removal_code"
    assert_equal 818, license.motherboard_bios, "motherboard_bios"
    assert_equal 30, license.cpu, "cpu"
    assert_equal 44, license.hard_drive, "hard_drive"
  end

  test "should raise ArgumentError" do
    license = PCGuard.new
    assert_raise ArgumentError do
      license.generate
    end
  end

  test "should raise BadProgramID" do
    dummy = licenses(:dummy)
    assert_raise PCGuard::BadProgramID do
      PCGuard.new "XXXXXXXXXXXXXXXXXXXXXXXX", dummy.sitecode, dummy.mid
    end
  end

  test "should raise BadSiteCode" do
    dummy = licenses(:dummy)
    assert_raise PCGuard::BadSiteCode do
      PCGuard.new dummy.application.ProgramID, "XXXXXXXX", dummy.mid
    end
  end

  test "should raise BadMID" do
    dummy = licenses(:dummy)
    assert_raise PCGuard::BadMID do
      PCGuard.new dummy.application.ProgramID, dummy.sitecode, "8E98FE2DC8B73C55"
    end
  end

  test "should raise MIDCodeError" do
    dummy = licenses(:dummy)
    assert_raise PCGuard::MIDCodeError do
      PCGuard.new dummy.application.ProgramID, dummy.sitecode, "7477-9B00-2BBA-80F9"
    end
  end

end
