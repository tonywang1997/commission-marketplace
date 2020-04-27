require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
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

  test "should get index" do
    get messages_url
    assert_response :success
  end

end
