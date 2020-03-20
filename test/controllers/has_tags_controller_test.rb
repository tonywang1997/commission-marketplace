require 'test_helper'

class HasTagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @has_tag = has_tags(:one)
  end

  test "should get index" do
    get has_tags_url
    assert_response :success
  end

  test "should get new" do
    get new_has_tag_url
    assert_response :success
  end

  test "should create has_tag" do
    assert_difference('HasTag.count') do
      post has_tags_url, params: { has_tag: { artist_id: @has_tag.artist_id, tag_id: @has_tag.tag_id } }
    end

    assert_redirected_to has_tag_url(HasTag.last)
  end

  test "should show has_tag" do
    get has_tag_url(@has_tag)
    assert_response :success
  end

  test "should get edit" do
    get edit_has_tag_url(@has_tag)
    assert_response :success
  end

  test "should update has_tag" do
    patch has_tag_url(@has_tag), params: { has_tag: { artist_id: @has_tag.artist_id, tag_id: @has_tag.tag_id } }
    assert_redirected_to has_tag_url(@has_tag)
  end

  test "should destroy has_tag" do
    assert_difference('HasTag.count', -1) do
      delete has_tag_url(@has_tag)
    end

    assert_redirected_to has_tags_url
  end
end
