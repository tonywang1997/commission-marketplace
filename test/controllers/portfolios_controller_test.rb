require 'test_helper'

class PortfoliosControllerTest < ActionDispatch::IntegrationTest
  setup do
    # load the user from the fixtures
    @user = users(:aria)
  end

  test "should get storefront as visitor" do
    get "/storefront?user_id=#{@user.id}"
    assert_response :success
  end

  test "should get storefront as logged-in user" do
    post login_url, params: { session: { user_name:  "aria",
                                         password:   "123456"} }
    get "/storefront?user_id=#{@user.id}"
    assert_response :success
    delete logout_url
  end

  test "visitor should not get portfolio creation page" do
    get user_submit_url 
    assert_redirected_to root_path
    assert flash[:danger] = 'Please register.'
  end

  test "logged-in user should get portfolio creation page" do
    post login_url, params: { session: { user_name:  "aria",
                                         password:   "123456"} }
    get user_submit_url 
    assert_response :success
    delete logout_url
  end

  test "visitor should not post a portfolio" do
    post portfolios_url, 
        params: { 
          portfolio: { 
            title: "test portfolio",
            description: "test description",
            files: [fixture_file_upload('files/test1.png', 'image/png'), 
                    fixture_file_upload('files/test2.png', 'image/png')],
            tags_attributes: {"0"=>{"tag_name"=>"anime"}, 
                              "1"=>{"tag_name"=>"realistic"}}, 
            "img-0-price" => "100", 
            "img-1-price"=> "100"
          }
        }
    assert_redirected_to root_path
    assert flash[:danger] = 'Please register.'
  end

  test "logged-in user can post a portfolio" do  
    post login_url, params: { session: { user_name:  "aria",
                                         password:   "123456"} }
    assert_difference('Portfolio.count') do
      post portfolios_url, 
        params: { 
          portfolio: { 
            title: "test portfolio",
            description: "test description",
            files: [fixture_file_upload('files/test1.png', 'image/png'), 
                    fixture_file_upload('files/test2.png', 'image/png')],
            tags_attributes: {"0"=>{"tag_name"=>"anime"}, 
                              "1"=>{"tag_name"=>"realistic"}}, 
            "img-0-price" => "100", 
            "img-1-price"=> "100"
        }
      }
    end
    # puts Portfolio.last.images.length
    assert_redirected_to portfolio_url(Portfolio.last) 
    assert flash[:notice] = 'Portfolio was successfully created.'
    delete logout_url
  end

  test "visitor should see a portfolio" do
    get portfolio_url(Portfolio.last) 
    assert_response :success
  end

  test "logged-in user should see a portfolio" do
    post login_url, params: { session: { user_name:  "aria",
                                         password:   "123456"} }
    get portfolio_url(Portfolio.last) 
    assert_response :success                                  
  end


end
