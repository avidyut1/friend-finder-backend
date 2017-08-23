require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get fetch" do
    get users_fetch_url
    assert_response :success
  end

end
