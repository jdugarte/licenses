require 'test_helper'

class LicensesControllerTest < ActionController::TestCase

  # index
  test "should get index signed in" do
    sign_in users(:dist_user)
    get :index
    assert_response :success
    assert_not_nil assigns(:licenses)
  end
  test "should not get index while not signed in" do
    get :index
    assert_redirected_to new_user_session_path
  end
  test "should not get index while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    get :index
    assert_redirected_to root_path
  end

  # new
  test "should get new" do
    sign_in users(:dist_user)
    get :new
    assert_response :success
  end
  test "should not get new while not signed in" do
    get :new
    assert_redirected_to new_user_session_path
  end
  test "should not get new while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    get :new
    assert_redirected_to root_path
  end
  
  # create
  test "should create license" do
    sign_in users(:dist_user)
    assert_difference('License.count') do
      post :create, license: get_new_license
    end
    assert assigns(:license).unprocessed?, "unprocessed?"
    assert_redirected_to new_license_path
  end
  test "should not create license while not signed in" do
    assert_no_difference('License.count') do
      post :create, license: get_new_license
    end
    assert_redirected_to new_user_session_path
  end
  test "should not create license while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    assert_no_difference('License.count') do
      post :create, license: get_new_license
    end
    assert_redirected_to root_path
  end
  
  # show
  test "should show license" do
    sign_in users(:dist_user)
    get :show, id: licenses(:processed1)
    assert_response :success
  end
  test "should not show license while not signed in" do
    get :show, id: licenses(:processed1)
    assert_redirected_to new_user_session_path
  end
  test "should not show license while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    get :show, id: licenses(:processed1)
    assert_redirected_to root_path
  end
  
  private
  
    def get_new_license
      { application_id: applications(:dummy).id, computer_id: computers(:transfer_dest), sitecode: "B4CB6928", mid: "97CC-881B-1395-FFB3", user_id: users(:dist_user).id }
    end
  
end
