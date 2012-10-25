require 'test_helper'

class ApplicationsControllerTest < ActionController::TestCase
  setup do
    @application = applications(:accounting)
  end
  
  # index
  test "should get index signed in" do
    sign_in users(:logiciel_admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:applications)
  end
  test "should not get index while not signed in" do
    get :index
    assert_redirected_to new_user_session_path
  end
  test "should not get index while not signed in as admin and main" do
    sign_in users(:master_admin)
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
  test "should not get new while not signed in as admin and main" do
    sign_in users(:master_admin)
    get :new
    assert_redirected_to root_path
  end
  
  # create
  test "should create application" do
    sign_in users(:logiciel_admin)
    assert_difference('Application.count') do
      post :create, application: get_new_application
    end
    assert_redirected_to application_path(assigns(:application))
  end
  test "should not create application while not signed in" do
    assert_no_difference('Application.count') do
      post :create, application: get_new_application
    end
    assert_redirected_to new_user_session_path
  end
  test "should not create application while not signed in as admin and main" do
    sign_in users(:master_admin)
    assert_no_difference('Application.count') do
      post :create, application: get_new_application
    end
    assert_redirected_to root_path
  end
  
  # show
  test "should show application" do
    sign_in users(:logiciel_admin)
    get :show, id: @application
    assert_response :success
  end
  test "should not show application while not signed in" do
    get :show, id: @application
    assert_redirected_to new_user_session_path
  end
  test "should not show application while not signed in as admin" do
    sign_in users(:master_admin)
    get :show, id: @application
    assert_redirected_to root_path
  end
  
  # edit
  test "should get edit" do
    sign_in users(:logiciel_admin)
    get :edit, id: @application
    assert_response :success
  end
  test "should not get edit while not signed in" do
    get :edit, id: @application
    assert_redirected_to new_user_session_path
  end
  test "should not get edit while not signed in as admin" do
    sign_in users(:master_admin)
    get :edit, id: @application
    assert_redirected_to root_path
  end
  
  # update
  test "should update application" do
    sign_in users(:logiciel_admin)
    put :update, id: @application, application: { ProgramID: @application.ProgramID, name: @application.name, price: @application.price }
    assert_redirected_to application_path(assigns(:application))
  end
  test "should not update application while not signed in" do
    put :update, id: @application, application: { name: @application.name }
    assert_redirected_to new_user_session_path
  end
  test "should not update application while not signed in as admin" do
    sign_in users(:master_admin)
    put :update, id: @application, application: { name: @application.name }
    assert_redirected_to root_path
  end
  
  # destroy
  test "should destroy application" do
    sign_in users(:logiciel_admin)
    assert_difference('Application.count', -1) do
      delete :destroy, id: @application
    end
    assert_redirected_to applications_path
  end
  test "should not destroy application while not signed in" do
    assert_no_difference('Application.count') do
      delete :destroy, id: @application
    end
    assert_redirected_to new_user_session_path
  end
  test "should not destroy application while not signed in as admin" do
    sign_in users(:master_admin)
    assert_no_difference('Application.count') do
      delete :destroy, id: @application
    end
    assert_redirected_to root_path
  end

  private
  
  def get_new_application
    { name: 'New application', ProgramID: '7F8FOIFKRI48RUJFNFIFI4RU', price: 9.99 }
  end
  
end
