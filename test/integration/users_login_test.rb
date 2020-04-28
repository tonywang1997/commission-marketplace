require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test 'redirect and flash appears' do
    get login_path
    assert_redirected_to root_path
    assert flash[:danger] = 'Please log in.'
  end
end
