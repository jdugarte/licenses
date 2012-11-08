require 'test_helper'

class LicenseOperationsTest < ActionDispatch::IntegrationTest

  fixtures :all
  
  test "life cycle of a license" do

    # login as distributor user
    login_as users(:dist_admin).email
    
    # create client
    get new_client_path
    assert_response :success
    post_via_redirect clients_path, :client => { :name => "Test Client", :email => "test_client@local.com" }
    client = assigns(:client)
    assert_equal client_path(client), path

    # create computer
    get new_client_computer_path(client.id)
    assert_response :success
    post client_computers_path, :client_id => client.id, :computer => { :name => "Test Computer" }
    computer = assigns(:computer)
    follow_redirect!
    assert_equal client_path(client), path

    unless Licenses::Application.config.generate_dummy_licenses

      # request license
      application = applications(:dummy)
      get new_license_path
      assert_response :success
      post licenses_path, :license => { :application_id => application.id, :computer_id => computer.id, :sitecode => "6A345B04", :mid => "C8E9-2DD9-D128-CCDD" }
      license = assigns(:license)
      follow_redirect!
      assert_equal new_license_path, path
      
      # approve license
      get process_path
      assert_response :success
      put_via_redirect process_path, :license => { license.id => "1" }, commit: "Approve"
      assert_equal process_path, path

      # renew license
      get edit_license_path(license)
      assert_response :success
      put_via_redirect license_path, :license => { :sitecode => "FEE7B707", :mid => "4C87-4DC1-ACA4-3617" }
      license = assigns(:license)
      assert_equal license_path(license), path
      
      # create new computer to transfer
      get new_client_computer_path(client.id)
      assert_response :success
      post client_computers_path, :client_id => client.id, :computer => { :name => "Test Computer 2" }
      computer = assigns(:computer)
      follow_redirect!
      assert_equal client_path(client), path

      # transfer license
      get transfer_path(license)
      assert_response :success
      put_via_redirect transfer_path, :license => { :removal_code => "024F4C22", :computer_id => computer.id, :sitecode => "662D9D47", :mid => "97C3-2BFA-3F59-D6DB" }
      license = assigns(:license)
      assert_equal license_path(license), path
      
      # remove license
      get remove_license_path(license)
      assert_response :success
      delete_via_redirect license_path(license), :license => { :removal_code => "6CBBF7E2" }
      license = assigns(:license)
      assert_equal license_path(license), path
    
    end
    
    # logout
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
  
end
