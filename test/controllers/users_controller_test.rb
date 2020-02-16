require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.new(
      user_name: 'test_user',
      email_address: 'test_user@x.com',
      password: 'test123',
      password_confirmation: 'test123',
      profile_thumbnail: 'idk',
    )
    @user.save
  end

  test "should get show" do
    get user_url User.first.id
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url User.first.id
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

end
