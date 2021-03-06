require 'test_helper'

class ClientTest < ActiveSupport::TestCase

  test "should not have empty name email" do
    client = Client.new 
    assert client.invalid?, "invalid?"
    assert client.errors[:name].any?, "name"
    assert client.errors[:email].any?, "email"
    assert !client.save
  end

  test "should have unique name per distributor" do
    client1 = Client.create(get_new_client)
    assert client1.valid?
    client2 = Client.new(get_new_client)
    assert client2.invalid?, "invalid?"
    assert client2.errors[:name].any?, "name"
    assert !client2.save
  end
  
  test "should be able to repeat name in different distributors" do
    client1 = Client.create(get_new_client)
    assert client1.valid?
    client2 = Client.new(get_new_client)
    client2.distributor_id = 2
    assert client2.valid?, "valid?"
    assert client2.errors.empty?, "no errors"
    assert client2.save
  end
  
  test "requesting scope should return only unique clients with unprocessed licenses" do
    req_clients = Client.requesting
    req_clients.reload
    assert_equal 2, req_clients.size
    assert req_clients.include?(clients(:client1))
    assert req_clients.include?(clients(:client2))
    assert !req_clients.include?(clients(:client3)), "Client without a license request"
    assert !req_clients.include?(clients(:client4)), "Client with only active licenses"
  end
  
  private
  
    def get_new_client
      { name: 'New client', email: 'new_client@local.com', distributor_id: 1 }
    end
  
end
