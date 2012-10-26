require 'test_helper'

class ComputersControllerTest < ActionController::TestCase

  setup do
    @computer = computers(:pc1)
  end

  # edit
  test "should get edit" do
    sign_in users(:dist_user)
    get :edit, client_id: @computer.client, id: @computer
    assert_response :success
  end
  test "should not get edit while not signed in" do
    get :edit, client_id: @computer.client, id: @computer
    assert_redirected_to new_user_session_path
  end
  test "should not get edit while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    get :edit, client_id: @computer.client, id: @computer
    assert_redirected_to root_path
  end
  
  # update
  test "should update computer" do
    sign_in users(:dist_user)
    put :update, client_id: @computer.client, id: @computer, computer: { name: @computer.name }
    assert_redirected_to client_path(assigns(:client))
  end
  test "should not update computer while not signed in" do
    put :update, client_id: @computer.client, id: @computer, computer: { name: @computer.name }
    assert_redirected_to new_user_session_path
  end
  test "should not update computer while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    put :update, client_id: @computer.client, id: @computer, computer: { name: @computer.name }
    assert_redirected_to root_path
  end

end
