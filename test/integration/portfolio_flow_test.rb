require 'test_helper'

class PortfolioFlowTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "the portfolio creation flow" do  
  	# log in
    post login_url, params: { session: { user_name:  "aria",
                                         password:   "123456"} }
    # go to dashboard
    get dashboard_url
    assert_response :success

    # create a portfolio 
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
    # redirected to portfolio show page with a 
    # success flash
    assert_redirected_to portfolio_url(Portfolio.last) 
    assert flash[:notice] = 'Portfolio was successfully created.'
    delete logout_url
  end

end
