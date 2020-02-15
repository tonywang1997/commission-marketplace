require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = User.new(
      user_name: 'test_user',
      email_address: 'test_user@x.com',
      password: 'test',
      profile_thumbnail: 'idk',
    )
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'should have user_name' do
    @user.user_name = '   '
    assert_not @user.valid?
  end

  test 'should have email_address' do
    @user.email_address = '   '
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email_address = 'a' * 256
    assert_not @user.valid?
  end

  test 'user_name should not be too long' do
    @user.user_name = 'a' * 256
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         USER@FOO.COM first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email_address = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.push('foo bar@a.com')
    invalid_addresses.each do |invalid_address|
      @user.email_address = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'duplicate emails not allowed' do
    user_dup = @user.dup
    @user.email_address = @user.email_address.upcase
    assert user_dup.valid?
    @user.save
    assert_not user_dup.valid?
  end

  test 'email is downcased on save' do
    mixed_case_email = 'fOo@bAR.Com'
    @user.email_address = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email_address
  end

  test 'duplicate user_name is not allowed' do
    user_dup = @user.dup
    @user.user_name = @user.user_name.upcase
    assert user_dup.valid?
    @user.save
    assert_not user_dup.valid?
  end

  test 'user_name is downcased on save' do
    mixed_case_user_name = 'uSEr_NAMe'
    @user.user_name = mixed_case_user_name
    @user.save
    assert_equal mixed_case_user_name.downcase, @user.reload.user_name
  end
end
