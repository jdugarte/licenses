require 'test_helper'

class DashboardControllerTest < ActionController::TestCase

  test "should get index signed in" do
    sign_in users(:user1)
    get :index
    assert_response :success
  end
  test "should not get index while not signed in" do
    get :index
    assert_redirected_to new_user_session_path
  end

end
