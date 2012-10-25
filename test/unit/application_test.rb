require 'test_helper'

class ApplicationTest < ActiveSupport::TestCase

  test "should not have empty name ProgramID" do
    application = Application.new 
    assert application.invalid?, "invalid?"
    assert application.errors[:name].any?, "name"
    assert application.errors[:ProgramID].any?, "ProgramID"
    assert !application.save
  end

end
