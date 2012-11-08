require 'test_helper'

class CreateDistributorsAndUsersTest < ActionDispatch::IntegrationTest

  test "create tree of distributors and their users" do
    
    logiciel = seed_db
    
    # login as main distributor
    login_as logiciel.email
    
    # Create master distributor
    create_distributor_and_admin_user "Test Master Distributor", "Test Master Admin", "test_master_admin@local.com"
    
    # logout as main distributor
    logout
    
    # login as master distributor
    login_as "test_master_admin@local.com"

    # Create distributor
    create_distributor_and_admin_user "Test Distributor", "Test Distributor Admin", "test_dist_admin@local.com"

    # logout as master distributor
    logout

    # login as distributor
    login_as "test_master_admin@local.com"

    # Create distributor user
    get new_user_path
    assert_response :success
    post_via_redirect users_path, :user => { :name => "Test Distributor User", :email => "test_dist_user@local.com", :password => "123123", :password_confirmation => "123123", :admin => false }
    assert_equal user_path(assigns(:user)), path

    # logout as distributor
    logout

    # login as distributor user
    login_as "test_dist_user@local.com"

    # logout as distributor user
    logout

  end
  
  private
  
  def login_as(email)
    get new_user_session_path
    assert_response :success
    post_via_redirect user_session_path, :user => { :email => email, :password => "123123" }
    assert_equal '/', path
  end
  
  def logout
    delete destroy_user_session_path
    follow_redirect!
    follow_redirect!
    assert_equal new_user_session_path, path
  end
  
  def create_distributor_and_admin_user(dist_name, user_name, email)
    get new_distributor_path
    assert_response :success
    post_via_redirect distributors_path, :distributor => { :name => dist_name, :users_attributes => { "0" => { :name => user_name, :email => email, :password => "123123", :password_confirmation => "123123" } } }
    assert_equal distributor_path(assigns(:distributor)), path
  end
  
  def seed_db
    main_dist = Distributor.create :name => 'Test Main Distributor', :main => true
    User.create :name => 'Test Main Admin', :email => 'test_main@local.com', :password => '123123', 
                :password_confirmation => '123123', :distributor_id => main_dist.id, 
                :admin => true
  end
  
end
