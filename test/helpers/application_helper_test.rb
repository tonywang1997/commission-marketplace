require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  # todo search string ignore punctuation?

  test "parse search string tags" do
    tags = "these are some basic tags"
    parsed = parse_search_string(tags)
    assert_equal ['these', 'are', 'some', 'basic', 'tags'].sort, parsed[:tags].sort
    assert_empty parsed[:price_range]
  end

  test "parse search string extra whitespace" do
    tags = "   these  are some      basic     tags"
    parsed = parse_search_string(tags)
    assert_equal ['these', 'are', 'some', 'basic', 'tags'].sort, parsed[:tags].sort
    assert_empty parsed[:price_range]
  end

  test "parse search string repeated tags" do
    tags = "these tags are tags repeated repeated repeated why are they why are they repeated"
    parsed = parse_search_string(tags)
    assert_equal tags.split(' ').uniq.sort, parsed[:tags].sort
    assert_empty parsed[:price_range]
  end

  test "parse search string price range basic" do
    basic_price_ranges = ["$20-$30", "20-$30", "$20-30", "20-30", "20.0-30.0"]
    basic_price_ranges.each do |range|
      parsed = parse_search_string(range)
      assert_equal [20, 30], parsed[:price_range]
      assert_empty parsed[:tags]
    end
  end

  test "parse search string price range implicit lower bound" do
    range = "-300"
    parsed = parse_search_string(range)
    assert_equal [0, 300], parsed[:price_range]
    assert_empty parsed[:tags]
  end

  test "parse search string price range implicit upper bound" do
    range = "50-"
    parsed = parse_search_string(range)
    assert_equal [50, Float::INFINITY], parsed[:price_range]
    assert_empty parsed[:tags]
  end

  test "parse search string price range implicit upper/lower bounds" do
    range = "-"
    parsed = parse_search_string(range)
    assert_equal [0, Float::INFINITY], parsed[:price_range]
    assert_empty parsed[:tags]
  end

  test "parse search string multiple price ranges pick first, ignore the rest" do
    search = "$20-30 15-600 -200 50-"
    parsed = parse_search_string(search)
    assert_equal [20, 30], parsed[:price_range]
    assert_empty parsed[:tags]
  end

  test "parse search string tags with hyphens" do
    search = "this-that this-and-that -this that- -and-"
    parsed = parse_search_string(search)
    assert_equal search.split(' ').sort, parsed[:tags].sort
    assert_empty parsed[:price_range]
  end

  test "parse search string advanced 1" do
    search = " this is a super duper advanced   search string with a 3-5 price range or maybe $30-40   "
    parsed = parse_search_string(search)
    expected = search.split(' ').delete('3-5')
    assert_equal search.split(' ').uniq.sort - ['3-5', '$30-40'], parsed[:tags].sort
    assert_equal [3, 5], parsed[:price_range]
  end
end