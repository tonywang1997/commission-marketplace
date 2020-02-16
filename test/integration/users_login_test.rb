require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test 'flash disappears' do
    get login_path
    assert_response :success
    assert_template 'sessions/new'
    post login_path, params: { session: {user_name: 'nonexistent',
                                          password: '',
                                        }}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end
