require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  test "tagged scope works" do
    seed_test_images
    # seed_test_users(1)
    seed_test_portfolios(3)

    tagged_one = Image.select(:id).sample(5)
    tagged_two = Image.select(:id).sample(5)
    tagged_three = Image.select(:id).sample(5)

    portfolios = Portfolio.all.to_a
    portfolio_one = portfolios[0]
    portfolio_two = portfolios[1]
    portfolio_three = portfolios[2]

    portfolio_one.tags.push(Tag.find_by(tag_name: 'one'))
    tagged_one.each do |image|
      portfolio_one.images.push(image)
    end

    portfolio_two.tags.push(Tag.find_by(tag_name: 'two'))
    tagged_two.each do |image|
      portfolio_two.images.push(image)
    end

    portfolio_three.tags.push(Tag.find_by(tag_name: 'three'))
    tagged_three.each do |image|
      portfolio_three.images.push(image)
    end

    assert_equal tagged_one.pluck(:id).sort, Image.tagged(['one']).pluck(:id).sort
    assert_equal tagged_two.pluck(:id).sort, Image.tagged(['two']).pluck(:id).sort
    assert_equal tagged_three.pluck(:id).sort, Image.tagged(['three']).pluck(:id).sort
    assert_equal (tagged_one.pluck(:id) & tagged_two.pluck(:id)).sort, Image.tagged(['one', 'two']).pluck(:id).sort
    assert_equal (tagged_one.pluck(:id) & tagged_three.pluck(:id)).sort, Image.tagged(['one', 'three']).pluck(:id).sort
    assert_equal (tagged_two.pluck(:id) & tagged_three.pluck(:id)).sort, Image.tagged(['two', 'three']).pluck(:id).sort
    assert_equal (tagged_one.pluck(:id) & tagged_two.pluck(:id) & tagged_three.pluck(:id)).sort, Image.tagged(['one', 'two', 'three']).pluck(:id).sort
  end

  test "tagged scope does not filter when tags is nil or empty" do
  end

  test "in_price_range scope works" do
  end

  test "in_price_range scope does not filter when price_range is nil or empty" do
  end

  test "in_price_range scope raises error when price_range has incorrect format" do
  end

  test "chaining tagged and in_price_range scopes works" do
  end

  test "chaining tagged and in_price_range scopes works when tags is empty" do
  end

  test "chaining tagged and in_price_range scopes works when tags is nil" do
  end

  test "chaining tagged and in_price_range scopes works when price_range is empty" do
  end

  test "chaining tagged and in_price_range scopes works when price_range is nil" do
  end

  test "with_ids scope works with exclude == false" do
  end

  test "with_ids scope works with exclude == true" do
  end

  test "with_ids scope does not filter when ids is nil" do
  end

  test "with_ids scope works correctly when ids is empty and exclude == false" do
  end

  test "with_ids scope works correctly when ids is empty and exclude == true" do
  end

  test "tags class method works correctly" do
  end

  test "tags class method works correctly when image_ids is empty" do
  end

  test "portfolios class method works correctly" do
  end

  test "portfolios class method works correctly when image_ids is empty" do
  end

  test "tags instance method works correctly" do
  end

  test "tags instance method works correctly when image has no tags" do
  end

  test "tags instance method works correctly when image is in multiple portfolios" do
  end


end
