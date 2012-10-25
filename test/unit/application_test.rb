require 'test_helper'

class ApplicationTest < ActiveSupport::TestCase

  test "should not have empty name ProgramID" do
    application = Application.new 
    assert application.invalid?, "invalid?"
    assert application.errors[:name].any?, "name"
    assert application.errors[:ProgramID].any?, "ProgramID"
    assert !application.save
  end

  test "should have unique name" do
    application1 = Application.create(get_new_application)
    assert application1.valid?
    application2 = Application.new(get_new_application)
    assert application2.invalid?, "invalid?"
    assert application2.errors[:name].any?, "name"
    assert !application2.save
  end
  
  def get_new_application
    { name: 'New application', ProgramID: '7F8FOIFKRI48RUJFNFIFI4RU', price: 9.99 }
  end
  
end
