require 'test_helper'

class ComputersControllerTest < ActionController::TestCase

  setup do
    @computer = computers(:pc1)
  end

  # new
  test "should get new" do
    sign_in users(:dist_user)
    get :new, client_id: @computer.client
    assert_response :success
  end
  test "should not get new while not signed in" do
    get :new, client_id: @computer.client
    assert_redirected_to new_user_session_path
  end
  test "should not get new while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    get :new, client_id: @computer.client
    assert_redirected_to root_path
  end
  
  # create
  test "should create computer" do
    sign_in users(:dist_user)
    assert_difference('Computer.count') do
      post :create, client_id: @computer.client, computer: get_new_computer
    end
    assert_redirected_to client_path(assigns(:client))
  end
  test "should not create computer while not signed in" do
    assert_no_difference('Computer.count') do
      post :create, client_id: @computer.client, computer: get_new_computer
    end
    assert_redirected_to new_user_session_path
  end
  test "should not create computer while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    assert_no_difference('Computer.count') do
      post :create, client_id: @computer.client, computer: get_new_computer
    end
    assert_redirected_to root_path
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
    put :update, client_id: @computer.client, id: @computer, computer: get_new_computer
    assert_redirected_to client_path(assigns(:client))
  end
  test "should not update computer while not signed in" do
    put :update, client_id: @computer.client, id: @computer, computer: get_new_computer
    assert_redirected_to new_user_session_path
  end
  test "should not update computer while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    put :update, client_id: @computer.client, id: @computer, computer: get_new_computer
    assert_redirected_to root_path
  end

  private
  
    def get_new_computer
      { name: 'New computer' }
    end
  
end
