require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup do
    @user = users(:user2)
  end
  
  # index
  test "should get index signed in" do
    sign_in users(:user1)
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end
  test "should not get index while not signed in" do
    get :index
    assert_redirected_to new_user_session_path
  end

  # new
  test "should get new" do
    sign_in users(:user1)
    get :new
    assert_response :success
  end
  test "should not get new while not signed in" do
    get :new
    assert_redirected_to new_user_session_path
  end
    
  # create
  test "should create user" do
    sign_in users(:user1)
    assert_difference('User.count') do
      post :create, user: { name: 'New user', email: 'new@local.com', password: '123123', password_confirmation: '123123' }
    end
    assert_redirected_to user_path(assigns(:user))
  end
  test "should not create user while not signed in" do
    assert_no_difference('User.count') do
      post :create, user: { name: 'New user', email: 'new@local.com', password: '123123', password_confirmation: '123123' }
    end
    assert_redirected_to new_user_session_path
  end
  
  # show
  test "should show user" do
    sign_in users(:user1)
    get :show, id: @user
    assert_response :success
  end
  test "should not show user while not signed in" do
    get :show, id: @user
    assert_redirected_to new_user_session_path
  end
  
  # edit
  test "should get edit" do
    sign_in users(:user1)
    get :edit, id: @user
    assert_response :success
  end
  test "should not get edit while not signed in" do
    get :edit, id: @user
    assert_redirected_to new_user_session_path
  end
  test "should not get edit on himself" do
    sign_in users(:user2)
    get :edit, id: @user
    assert_redirected_to users_path
  end
  
  # update
  test "should update user" do
    sign_in users(:user1)
    put :update, id: @user, user: { name: @user.name }
    assert_redirected_to user_path(assigns(:user))
  end
  test "should not update user while not signed in" do
    put :update, id: @user, user: { name: @user.name }
    assert_redirected_to new_user_session_path
  end
  test "should not update himself" do
    sign_in users(:user2)
    put :update, id: @user, user: { name: @user.name }
    assert_redirected_to users_path
  end
  
  # destroy
  test "should destroy user" do
    sign_in users(:user1)
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end
    assert_redirected_to users_path
  end
  test "should not destroy user while not signed in" do
    assert_no_difference('User.count') do
      delete :destroy, id: @user
    end
    assert_redirected_to new_user_session_path
  end
  test "should not destroy himself" do
    sign_in users(:user2)
    assert_no_difference('User.count') do
      delete :destroy, id: @user
    end
    assert_redirected_to users_path
  end

end
