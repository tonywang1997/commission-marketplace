require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_path
    assert_redirected_to root_path
    assert flash[:danger] = 'Please log in.'
  end

  # todo: write test for logging in, correct redirection
end
