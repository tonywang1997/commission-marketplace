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

  test "get matrices exclude specified ids" do
    seed_test_images
    all_ids = Image.all.where(analyzed: true).pluck(:id)
    ids = Image.all.sample(5).pluck(:id)
    matrices = get_matrices(exclude: true, ids: ids)
    assert_equal (all_ids - ids).sort, matrices.keys.sort
  end

  test "get matrices get only specified ids" do
    seed_test_images
    ids = Image.all.where(analyzed: true).sample(5).pluck(:id)
    matrices = get_matrices(exclude: false, ids: ids)
    assert_equal ids.sort, matrices.keys.sort
  end

  test "get matrices implicitly get all ids" do
    seed_test_images
    ids = Image.all.where(analyzed: true).pluck(:id)
    matrices = get_matrices
    assert_equal ids.sort, matrices.keys.sort
  end

  test "get matrices all values are 3d arrays" do
    seed_test_images
    Image.create # create blank image; should not exist in matrices
    matrices = get_matrices
    is_2d_array = true
    matrices.each do |id, matrix|
      is_2d_array = false unless !matrix.nil? and matrix.class == Array and 
        matrix[0].class == Array and matrix[0][0].class == Integer
      break unless is_2d_array
    end
    assert is_2d_array
  end

  test "calc similarities returns expected format" do
    seed_test_images
    matrices = get_matrices
    id_comp = matrices.keys.sample
    matrix_comp = matrices.delete(id_comp)
    sim_sums = calc_similarities(matrix_comp, matrices)

    assert_equal sim_sums.keys.sort, matrices.keys.sort
    is_int = true
    sim_sums.each do |id, sim|
      is_int = false unless sim.class == Integer
      break unless is_int
    end
    assert is_int
  end

  test "filter hash works with default values" do
    h = {}
    (0..500).to_a.each { |int| h[int] = int }
    filtered = filter_hash h
    assert_equal Hash, filtered.class
  end

  test "filter hash works with specified max value" do
    h = {}
    expected_h = {}
    (0..500).to_a.each { |int| h[int] = int }
    (0..50).to_a.each { |int| expected_h[int] = int }
    filtered = filter_hash h, max_val: 50
    assert_equal expected_h.sort, filtered.sort
  end

  test "filter hash works with specified max value and min size" do
    h = {}
    expected_h = {}
    (0..500).to_a.each { |int| h[int] = int }
    (0...50).to_a.each { |int| expected_h[int] = int }
    filtered = filter_hash h, max_val: -1, min_size: 50
    assert_equal expected_h.sort, filtered.sort
  end

  test "filter hash works with specified max value and min size 2" do
    h = {}
    expected_h = {}
    (0..500).to_a.each { |int| h[int] = int }
    (0...50).to_a.each { |int| expected_h[int] = int }
    filtered = filter_hash h, max_val: 25, min_size: 50
    assert_equal expected_h.sort, filtered.sort
  end

  test "get sorted images gets correct images" do
    seed_test_images
    sorter = {}
    ids = Image.all.sample(5).pluck(:id)
    ids.each { |id| sorter[id] = 0 }
    images = get_sorted_images sorter, [:id]
    images.each do |image|
      assert sorter.keys.include? image.id
    end
    assert_equal sorter.size, images.size
  end

  test "get sorted images gets correct attributes" do
    seed_test_images
    sorter = {}
    ids = Image.all.pluck(:id)
    ids.each { |id| sorter[id] = 0 }
    images = get_sorted_images sorter, [:id, :price, :analyzed]

    images.each do |image|
      begin
        image.id
        image.price
        image.analyzed
      rescue
        assert false
      end

      begin
        image.date
        assert false
      rescue
      end
    end
  end

  test "get sorted images sorts images correctly" do
    seed_test_images
    sorter = {}
    ids = Image.all.pluck(:id)
    ids.each_with_index { |id, idx| sorter[id] = idx }
    images = get_sorted_images sorter, [:id]
    images.each_with_index do |image, idx|
      assert_equal sorter[image.id], idx
    end
  end
end