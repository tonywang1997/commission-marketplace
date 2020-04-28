require 'test_helper'

class UsersRegisterTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test 'does not create user when invalid params' do
    get register_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { user_name:  "",
                                         email_address: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div.field_with_errors'
    assert_select 'div#error_explanation'
  end

  test 'creates user when valid params' do
    get register_path
    assert_difference 'User.count', 1 do
      post users_path, params: {user: {
                                        user_name: "eberl",
                                        email_address: "eberl@railstutorial.org",
                                        password: 'blah123',
                                        password_confirmation: 'blah123',
                                      } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert !!flash[:success]
  end

  test 'redirect and flash appears' do
    get register_path
    assert_redirected_to root_path
    assert flash[:danger] = 'Please register.'
  end
end
