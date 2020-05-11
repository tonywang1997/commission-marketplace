require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @posts = Post.new(
      title: 'name',
      content: 'things inside',
      user_id: 3,
      price: 100,
    )
    @posts.save
  end

  test "post title accuracy" do
    y = @posts.title
    assert_equal 'name', y
  end 

  test "user id accuracy" do
    x = @posts.user_id
    assert_equal 3, x
  end

  test "user content accuracy" do
    z = @posts.content
    assert_equal 'things inside', z
  end

  test "user price accuracy" do
    z = @posts.price
    assert_equal 100, z
  end
  
end
