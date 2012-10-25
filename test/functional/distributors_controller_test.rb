require 'test_helper'

class DistributorsControllerTest < ActionController::TestCase

  setup do
    @distributor = distributors(:master)
  end
  
  # index
  test "should get index signed in" do
    sign_in users(:logiciel_admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:distributors)
  end
  test "should not include distributors from other distributors" do
    sign_in users(:logiciel_admin)
    get :index
    assert !assigns(:distributors).include?(distributors(:dist1))
  end
  test "should not get index while not signed in" do
    get :index
    assert_redirected_to new_user_session_path
  end
  test "should not get index while not signed in as admin" do
    sign_in users(:master_user)
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
  test "should create distributor and admin user" do
    sign_in users(:logiciel_admin)
    assert_difference('Distributor.count') do
      assert_difference('User.count') do
        post :create, distributor: { name: @distributor.name, users_attributes: { "0" => { name: 'New user', email: 'new@local.com', password: '123123', password_confirmation: '123123', admin: true } } }
      end
    end
    assert_redirected_to distributor_path(assigns(:distributor))
    assert(assigns(:distributor).users.first.admin)
  end
  test "should not create distributor while not signed in" do
    assert_no_difference('Distributor.count') do
      post :create, distributor: { name: @distributor.name }
    end
    assert_redirected_to new_user_session_path
  end
  test "should not create distributor while not signed in as admin" do
    sign_in users(:master_user)
    assert_no_difference('Distributor.count') do
      post :create, distributor: { name: @distributor.name }
    end
    assert_redirected_to root_path
  end
  
  # show
  test "should show distributor" do
    sign_in users(:logiciel_admin)
    get :show, id: @distributor
    assert_response :success
  end
  test "should not show a distributor from other distributor" do
    sign_in users(:logiciel_admin)
    get :show, id: distributors(:dist1)
    assert_redirected_to distributors_path
  end
  test "should not show distributor while not signed in" do
    get :show, id: @distributor
    assert_redirected_to new_user_session_path
  end
  test "should not show distributor while not signed in as admin" do
    sign_in users(:master_user)
    get :show, id: @distributor
    assert_redirected_to root_path
  end
  
  # edit
  test "should get edit" do
    sign_in users(:logiciel_admin)
    get :edit, id: @distributor
    assert_response :success
  end
  test "should not edit a distributor from other distributor" do
    sign_in users(:logiciel_admin)
    get :edit, id: distributors(:dist1)
    assert_redirected_to distributors_path
  end
  test "should not get edit while not signed in" do
    get :edit, id: @distributor
    assert_redirected_to new_user_session_path
  end
  test "should not get edit while not signed in as admin" do
    sign_in users(:master_user)
    get :edit, id: @distributor
    assert_redirected_to root_path
  end
  
  # update
  test "should update distributor" do
    sign_in users(:logiciel_admin)
    put :update, id: @distributor, distributor: { name: @distributor.name }
    assert_redirected_to distributor_path(assigns(:distributor))
  end
  test "should not update a distributor from other distributor" do
    sign_in users(:logiciel_admin)
    dist1 = distributors(:dist1)
    put :update, id: dist1.id, distributor: { name: dist1.name }
    assert_redirected_to distributors_path
  end
  test "should not update distributor while not signed in" do
    put :update, id: @distributor, distributor: { name: @distributor.name }
    assert_redirected_to new_user_session_path
  end
  test "should not update distributor while not signed in as admin" do
    sign_in users(:master_user)
    put :update, id: @distributor, distributor: { name: @distributor.name }
    assert_redirected_to root_path
  end
  
  # destroy
  test "should destroy distributor" do
    sign_in users(:logiciel_admin)
    assert_difference('Distributor.count', -1) do
      delete :destroy, id: @distributor
    end
    assert_redirected_to distributors_path
  end
  test "should not destroy a distributor from other distributor" do
    sign_in users(:logiciel_admin)
    assert_no_difference('Distributor.count') do
      delete :destroy, id: distributors(:dist1)
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
    sign_in users(:master_user)
    assert_no_difference('Distributor.count') do
      delete :destroy, id: @distributor
    end
    assert_redirected_to root_path
  end

end
