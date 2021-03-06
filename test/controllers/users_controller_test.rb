require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include SessionsHelper

  def setup
    @user = User.new(
      user_name: 'test_user123',
      email_address: 'test_user123@x.com',
      password: 'test123',
      password_confirmation: 'test123',
      profile_thumbnail: 'idk',
    )
    @user.save
    post login_path, params: { session: { user_name:    @user.user_name,
                                          password: 'test123' } }
  end

  test "should get show" do
    get user_url(@user.user_name)
    assert_response :success
  end

  test "should get dashboard" do
    get dashboard_url
    assert_response :success
  end

  test "logged out user cannot access dashboard" do
    delete logout_url
    get dashboard_url
    assert_redirected_to root_url
  end

end
