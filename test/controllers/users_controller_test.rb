require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get user_url 1
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url 1
    assert_response :success
  end

  test "should get new" do
    get register_path
    assert_response :success
  end

end
