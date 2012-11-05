require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup do
    @user = users(:user1)
  end
  
  # index
  test "should get index signed in" do
    sign_in users(:logiciel_admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    sign_in users(:dist_admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end
  test "should not include users from other distributors" do
    sign_in users(:logiciel_admin)
    get :index
    assert !assigns(:users).include?(users(:master_admin))
  end
  test "should not get index while not signed in" do
    get :index
    assert_redirected_to new_user_session_path
  end
  test "should not get index while not signed in as admin" do
    sign_in users(:master_user)
    get :index
    assert_redirected_to root_path
    sign_in users(:dist_user)
    get :index
    assert_redirected_to root_path
  end

  # new
  test "should get new" do
    sign_in users(:logiciel_admin)
    get :new
    assert_response :success
  end
  test "should not get new while not signed in" do
    get :new
    assert_redirected_to new_user_session_path
  end
  test "should not get new while not signed in as admin" do
    sign_in users(:master_user)
    get :new
    assert_redirected_to root_path
  end
    
  # create
  test "should create user" do
    sign_in users(:logiciel_admin)
    assert_difference('User.count') do
      post :create, user: get_new_user
    end
    assert_redirected_to user_path(assigns(:user))
    assert_equal assigns(:user).distributor, users(:logiciel_admin).distributor
  end
  test "should not create user while not signed in" do
    assert_no_difference('User.count') do
      post :create, user: get_new_user
    end
    assert_redirected_to new_user_session_path
  end
  test "should not create user while not signed in as admin" do
    sign_in users(:master_user)
    assert_no_difference('User.count') do
      post :create, user: get_new_user
    end
    assert_redirected_to root_path
  end
  test "main distributor should only create admin users" do
    sign_in users(:logiciel_admin)
    post :create, user: get_new_user
    assert(assigns(:user).admin)
  end
  test "distributors other than main should create regular users by default" do
    sign_in users(:master_admin)
    post :create, user: get_new_user
    assert !assigns(:user).admin
    sign_in users(:dist_admin)
    post :create, user: get_new_user
    assert !assigns(:user).admin
  end
  
  # show
  test "should show user" do
    sign_in users(:master_admin)
    get :show, id: users(:master_user)
    assert_response :success
  end
  test "should not show a user from other distributor" do
    sign_in users(:logiciel_admin)
    get :show, id: users(:master_admin)
    assert_redirected_to users_path
  end
  test "should not show user while not signed in" do
    get :show, id: @user
    assert_redirected_to new_user_session_path
  end
  test "should not show user while not signed in as admin" do
    sign_in users(:master_user)
    get :show, id: @user
    assert_redirected_to root_path
  end
  
  # edit
  test "should get edit" do
    sign_in users(:master_admin)
    get :edit, id: users(:master_user)
    assert_response :success
  end
  test "should not edit a user from other distributor" do
    sign_in users(:logiciel_admin)
    get :edit, id: users(:master_admin)
    assert_redirected_to users_path
  end
  test "should not get edit while not signed in" do
    get :edit, id: @user
    assert_redirected_to new_user_session_path
  end
  test "should not get edit while not signed in as admin" do
    sign_in users(:master_user)
    get :edit, id: @user
    assert_redirected_to root_path
  end
  test "should not get edit on himself" do
    admin = users(:logiciel_admin)
    sign_in admin
    get :edit, id: admin
    assert_redirected_to users_path
  end
  
  # update
  test "should update user" do
    sign_in users(:master_admin)
    master_user = users(:master_user)
    put :update, id: master_user.id, user: { name: master_user.name }
    assert_redirected_to user_path(assigns(:user))
  end
  test "should not update a user from other distributor" do
    sign_in users(:logiciel_admin)
    master_admin = users(:master_admin)
    put :update, id: master_admin.id, user: { name: master_admin.name }
    assert_redirected_to users_path
  end
  test "should not update user while not signed in" do
    put :update, id: @user, user: { name: @user.name }
    assert_redirected_to new_user_session_path
  end
  test "should not update user while not signed in as admin" do
    sign_in users(:master_user)
    put :update, id: @user, user: { name: @user.name }
    assert_redirected_to root_path
  end
  test "should not update himself" do
    admin = users(:logiciel_admin)
    sign_in admin
    put :update, id: admin, user: { name: admin.name }
    assert_redirected_to users_path
  end
  
  # destroy
  test "should destroy user" do
    sign_in users(:master_admin)
    assert_difference('User.count', -1) do
      delete :destroy, id: users(:master_user)
    end
    assert_redirected_to users_path
  end
  test "should not destroy a user from other distributor" do
    sign_in users(:logiciel_admin)
    assert_no_difference('User.count') do
      delete :destroy, id: users(:master_admin)
    end
    assert_redirected_to users_path
  end
  test "should not destroy user while not signed in" do
    assert_no_difference('User.count') do
      delete :destroy, id: @user
    end
    assert_redirected_to new_user_session_path
  end
  test "should not destroy user while not signed in as admin" do
    sign_in users(:master_user)
    assert_no_difference('User.count') do
      delete :destroy, id: @user
    end
    assert_redirected_to root_path
  end
  test "should not destroy himself" do
    admin = users(:logiciel_admin)
    sign_in admin
    assert_no_difference('User.count') do
      delete :destroy, id: admin
    end
    assert_redirected_to users_path
  end
  
  private
  
  def get_new_user
    { name: 'New user', email: 'new@local.com', password: '123123', password_confirmation: '123123' }
  end
  
end
