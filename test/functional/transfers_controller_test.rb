require 'test_helper'

class TransfersControllerTest < ActionController::TestCase

  setup do
    @license = licenses(:transfer)
  end

  # new
  test "should get new" do
    sign_in users(:dist_user)
    get :new, id: @license
    assert_response :success
  end
  test "should not get new while not signed in" do
    get :new, id: @license
    assert_redirected_to new_user_session_path
  end
  test "should not get new while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    get :new, id: @license
    assert_redirected_to root_path
  end
  
  # update
  test "should transfer license" do
    unless Licenses::Application.config.generate_dummy_licenses
      sign_in users(:dist_user)
      put :update, id: @license, license: get_transfer_license
      assert_redirected_to license_path(assigns(:license))
    end
  end
  test "should not transfer license while not signed in" do
    put :update, id: @license, license: get_transfer_license
    assert_redirected_to new_user_session_path
  end
  test "should not transfer license while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    put :update, id: @license, license: get_transfer_license
    assert_redirected_to root_path
  end

  private
  
  def get_transfer_license
    { removal_code: "341879DF", computer_id: computers(:transfer_dest).id, sitecode: "B4CB6928", mid: "97CC-881B-1395-FFB3", notes: "Transfer license" }
  end

end
