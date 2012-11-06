require 'test_helper'

class ProcessControllerTest < ActionController::TestCase

  # index
  test "should get index signed in" do
    sign_in users(:dist_admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:licenses)
  end
  test "should not get index while not signed in" do
    get :index
    assert_redirected_to new_user_session_path
  end
  test "should not get index while not signed in as admin distributor" do
    sign_in users(:logiciel_admin)
    get :index
    assert_redirected_to root_path
    sign_in users(:dist_user)
    get :index
    assert_redirected_to root_path
  end

  # update
  test "should approve license" do
    sign_in users(:dist_admin)
    put :update, license: { licenses(:unprocessed1).id => "1", licenses(:unprocessed2).id => "0"}, commit: "Approve"
    license1 = License.find licenses(:unprocessed1).id
    assert license1.active?
    license2 = License.find licenses(:unprocessed2).id
    assert license2.unprocessed?
    assert_redirected_to process_path
  end
  test "should reject license" do
    sign_in users(:dist_admin)
    put :update, license: { licenses(:unprocessed1).id => "1", licenses(:unprocessed2).id => "0"}, commit: "Reject"
    license1 = License.find licenses(:unprocessed1).id
    assert license1.rejected?
    license2 = License.find licenses(:unprocessed2).id
    assert license2.unprocessed?
    assert_redirected_to process_path
  end
  test "should not process while not signed in" do
    put :update, license: { licenses(:unprocessed1).id => "1", licenses(:unprocessed2).id => "0"}, commit: "Approve"
    assert_redirected_to new_user_session_path
  end
  test "should not process while not signed in as admin distributor" do
    sign_in users(:logiciel_admin)
    put :update, license: { licenses(:unprocessed1).id => "1", licenses(:unprocessed2).id => "0"}, commit: "Approve"
    assert_redirected_to root_path
    sign_in users(:dist_user)
    put :update, license: { licenses(:unprocessed1).id => "1", licenses(:unprocessed2).id => "0"}, commit: "Approve"
    assert_redirected_to root_path
  end

end
