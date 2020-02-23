require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test 'redirect and modal appears' do
    get login_path
    assert_redirected_to root_path
    assert flash[:misc_params][:show_login]
  end
end
