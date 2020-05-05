require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  test "should get root" do
    get root_url
    assert_response :success
  end



end