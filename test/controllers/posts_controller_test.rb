require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @posts = Post.new(
      title: 'name',
      content: 'things inside',
      user_id: '3',
      price: '100'
    )
    @posts.save
  end

  test "get post title" do
    x = @posts.title
    assert_response :success
  end

  test "post title accuracy" do
    y = @posts.title
    assert_equal 'name', y
  end 
end
