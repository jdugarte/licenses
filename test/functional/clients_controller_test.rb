require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  
  setup do
    @client = clients(:client1)
  end

  # index
  test "should get index signed in" do
    sign_in users(:dist_user)
    get :index
    assert_response :success
    assert_not_nil assigns(:clients)
  end
  test "should not get index while not signed in" do
    get :index
    assert_redirected_to new_user_session_path
  end
  test "should not get index while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    get :index
    assert_redirected_to root_path
    sign_in users(:master_admin)
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
  test "should create client" do
    sign_in users(:dist_user)
    assert_difference('Client.count') do
      post :create, client: get_new_client
    end
    assert_redirected_to client_path(assigns(:client))
  end
  test "should not create client while not signed in" do
    assert_no_difference('Client.count') do
      post :create, client: get_new_client
    end
    assert_redirected_to new_user_session_path
  end
  test "should not create client while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    assert_no_difference('Client.count') do
      post :create, client: get_new_client
    end
    assert_redirected_to root_path
  end
  
  # show
  test "should show client" do
    sign_in users(:dist_user)
    get :show, id: @client
    assert_response :success
  end
  test "should not show client while not signed in" do
    get :show, id: @client
    assert_redirected_to new_user_session_path
  end
  test "should not show client while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    get :show, id: @client
    assert_redirected_to root_path
  end
  
  # edit
  test "should get edit" do
    sign_in users(:dist_user)
    get :edit, id: @client
    assert_response :success
  end
  test "should not get edit while not signed in" do
    get :edit, id: @client
    assert_redirected_to new_user_session_path
  end
  test "should not get edit while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    get :edit, id: @client
    assert_redirected_to root_path
  end
  
  # update
  test "should update client" do
    sign_in users(:dist_user)
    put :update, id: @client, client: { name: @client.name, email: @client.email }
    assert_redirected_to client_path(assigns(:client))
  end
  test "should not update client while not signed in" do
    put :update, id: @client, client: { name: @client.name }
    assert_redirected_to new_user_session_path
  end
  test "should not update client while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    put :update, id: @client, client: { name: @client.name }
    assert_redirected_to root_path
  end
  
  # destroy
  test "should destroy client" do
    sign_in users(:dist_user)
    assert_difference('Client.count', -1) do
      delete :destroy, id: @client
    end
    assert_redirected_to clients_path
  end
  test "should not destroy client while not signed in" do
    assert_no_difference('Client.count') do
      delete :destroy, id: @client
    end
    assert_redirected_to new_user_session_path
  end
  test "should not destroy client while not signed in as distributor" do
    sign_in users(:logiciel_admin)
    assert_no_difference('Client.count') do
      delete :destroy, id: @client
    end
    assert_redirected_to root_path
  end

  private
  
  def get_new_client
    { name: 'New client', email: 'new_client@local.com', distributor_id: 1 }
  end
  
end
