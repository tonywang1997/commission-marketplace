require 'test_helper'

class PortfolioTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@portfolio = Portfolio.new(
		  title: "test portfolio model",
		  description: "test portfolio model",
		  date_created: Time.now)
  end

  test 'portfolio should not be dangling' do
    assert_not @portfolio.valid?
  end

  test 'portfolio should be valid after 
      setting user_id' do
    @portfolio.user_id = 1
    assert @portfolio.valid?
  end


end
