require 'test_helper'

class LicensesControllerTest < ActionController::TestCase

  setup do
    @license = licenses(:processed1)
  end

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
    get :show, id: @license
    assert_response :success
  end
  test "should not show license while not signed in" do
    get :show, id: @license
    assert_redirected_to new_user_session_path
  end
  test "should not show license while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    get :show, id: @license
    assert_redirected_to root_path
  end
  
  # edit
  test "should get edit" do
    sign_in users(:dist_user)
    get :edit, id: @license
    assert_response :success
  end
  test "should not get edit while not signed in" do
    get :edit, id: @license
    assert_redirected_to new_user_session_path
  end
  test "should not get edit while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    get :edit, id: @license
    assert_redirected_to root_path
  end
  test "should not get edit on a not active license" do
    sign_in users(:dist_user)
    get :edit, id: licenses(:unprocessed1)
    assert_redirected_to licenses_path
  end
  
  # update (renew)
  test "should renew license" do
    unless Licenses::Application.config.generate_dummy_licenses
      sign_in users(:dist_user)
      put :update, id: licenses(:renew_one), license: get_edit_license
      assert_redirected_to license_path(assigns(:license))
    end
  end
  test "should not renew license while not signed in" do
    put :update, id: licenses(:renew_one), license: get_edit_license
    assert_redirected_to new_user_session_path
  end
  test "should not renew license while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    put :update, id: licenses(:renew_one), license: get_edit_license
    assert_redirected_to root_path
  end

  # remove
  test "should get remove" do
    sign_in users(:dist_user)
    get :remove, id: @license
    assert_response :success
  end
  test "should not get remove while not signed in" do
    get :remove, id: @license
    assert_redirected_to new_user_session_path
  end
  test "should not get remove while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    get :remove, id: @license
    assert_redirected_to root_path
  end
  test "should not get remove on a not active license" do
    sign_in users(:dist_user)
    get :remove, id: licenses(:unprocessed1)
    assert_redirected_to licenses_path
  end
  
  # destroy (remove)
  test "should remove license" do
    sign_in users(:dist_user)
    delete :destroy, id: licenses(:renew_one), license: get_remove_license
    assert_redirected_to license_path(assigns(:license))
  end
  test "should not remove license while not signed in" do
    delete :destroy, id: licenses(:renew_one), license: get_remove_license
    assert_redirected_to new_user_session_path
  end
  test "should not remove license while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    delete :destroy, id: licenses(:renew_one), license: get_remove_license
    assert_redirected_to root_path
  end

  private
  
  def get_new_license
    { application_id: applications(:dummy).id, computer_id: computers(:transfer_dest), sitecode: "B4CB6928", mid: "97CC-881B-1395-FFB3", user_id: users(:dist_user).id }
  end

  def get_edit_license
    { sitecode: "044D4C09", mid: "8F33-D6E7-C3A0-426B", notes: "Update license" }
  end

  def get_remove_license
    { removal_code: "CA03FF8E", removal_reason: "Remove license" }
  end

end
