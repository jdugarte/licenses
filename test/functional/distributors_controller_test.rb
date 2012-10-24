require 'test_helper'

class DistributorsControllerTest < ActionController::TestCase

  setup do
    @distributor = distributors(:master)
  end
  
  # index
  test "should get index signed in" do
    sign_in users(:admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:distributors)
  end
  test "should not get index while not signed in" do
    get :index
    assert_redirected_to new_user_session_path
  end
  test "should not get index while not signed in as admin" do
    sign_in users(:user1)
    get :index
    assert_redirected_to root_path
  end

  # new
  test "should get new" do
    sign_in users(:admin)
    get :new
    assert_response :success
  end
  test "should not get new while not signed in" do
    get :new
    assert_redirected_to new_user_session_path
  end
  test "should not get new while not signed in as admin" do
    sign_in users(:user1)
    get :new
    assert_redirected_to root_path
  end
    
  # create
  test "should create distributor" do
    sign_in users(:admin)
    assert_difference('Distributor.count') do
      post :create, distributor: { name: @distributor.name }
    end
    assert_redirected_to distributor_path(assigns(:distributor))
  end
  test "should not create distributor while not signed in" do
    assert_no_difference('Distributor.count') do
      post :create, distributor: { name: @distributor.name }
    end
    assert_redirected_to new_user_session_path
  end
  test "should not create distributor while not signed in as admin" do
    sign_in users(:user1)
    assert_no_difference('Distributor.count') do
      post :create, distributor: { name: @distributor.name }
    end
    assert_redirected_to root_path
  end
  
  # show
  test "should show distributor" do
    sign_in users(:admin)
    get :show, id: @distributor
    assert_response :success
  end
  test "should not show distributor while not signed in" do
    get :show, id: @distributor
    assert_redirected_to new_user_session_path
  end
  test "should not show distributor while not signed in as admin" do
    sign_in users(:user1)
    get :show, id: @distributor
    assert_redirected_to root_path
  end
  
  # edit
  test "should get edit" do
    sign_in users(:admin)
    get :edit, id: @distributor
    assert_response :success
  end
  test "should not get edit while not signed in" do
    get :edit, id: @distributor
    assert_redirected_to new_user_session_path
  end
  test "should not get edit while not signed in as admin" do
    sign_in users(:user1)
    get :edit, id: @distributor
    assert_redirected_to root_path
  end
  
  # update
  test "should update distributor" do
    sign_in users(:admin)
    put :update, id: @distributor, distributor: { name: @distributor.name }
    assert_redirected_to distributor_path(assigns(:distributor))
  end
  test "should not update distributor while not signed in" do
    put :update, id: @distributor, distributor: { name: @distributor.name }
    assert_redirected_to new_user_session_path
  end
  test "should not update distributor while not signed in as admin" do
    sign_in users(:user1)
    put :update, id: @distributor, distributor: { name: @distributor.name }
    assert_redirected_to root_path
  end
  
  # destroy
  test "should destroy distributor" do
    sign_in users(:admin)
    assert_difference('Distributor.count', -1) do
      delete :destroy, id: @distributor
    end
    assert_redirected_to distributors_path
  end
  test "should not destroy distributor while not signed in" do
    assert_no_difference('Distributor.count') do
      delete :destroy, id: @distributor
    end
    assert_redirected_to new_user_session_path
  end
  test "should not destroy distributor while not signed in as admin" do
    sign_in users(:user1)
    assert_no_difference('Distributor.count') do
      delete :destroy, id: @distributor
    end
    assert_redirected_to root_path
  end

end
