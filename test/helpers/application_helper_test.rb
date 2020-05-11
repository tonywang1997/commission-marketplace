require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  # todo search string ignore punctuation?

  test "parse search string empty" do
    parsed = parse_search_string("")
    assert_equal({tags: [], price_range: []}.sort, parsed.sort)
  end

  test "parse search string nil" do
    parsed = parse_search_string(nil)
    assert_equal({tags: [], price_range: []}.sort, parsed.sort)
  end

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

  test "get matrices empty DB" do
    Image.destroy_all
    matrices = get_matrices
    assert_equal({}, matrices)
  end

  test "get matrices include image that doesn't exist in DB" do
    Image.destroy_all
    matrices = get_matrices(exclude: false, ids: [1, 2, 3])
    assert_equal({}, matrices)
  end

  test "get matrices exclude image that doesn't exist in DB" do
    Image.destroy_all
    matrices = get_matrices(exclude: true, ids: [1, 2, 3])
    assert_equal({}, matrices)
  end

  test "get matrices include empty ids" do
    seed_test_images
    matrices = get_matrices(exclude: false, ids: [])
    assert_equal({}, matrices)
  end

  test "get matrices exclude empty ids" do
    seed_test_images
    matrices = get_matrices(exclude: true, ids: [])
    assert_equal Image.where(analyzed: true).pluck(:id).sort, matrices.keys.sort
  end

  test "get matrices include nil ids" do
    seed_test_images
    matrices = get_matrices(exclude: false)
    assert_equal Image.where(analyzed: true).pluck(:id).sort, matrices.keys.sort
  end

  test "get matrices exclude nil ids" do
    seed_test_images
    matrices = get_matrices(exclude: true)
    assert_equal Image.where(analyzed: true).pluck(:id).sort, matrices.keys.sort
  end

  test "get matrices incorrect parameters" do
    seed_test_images
    matrices = get_matrices(blah: 123, blahblah: "blah")
    assert_equal Image.where(analyzed: true).pluck(:id).sort, matrices.keys.sort
  end

  test "get matrices exclude is nil (should include by default)" do
    seed_test_images
    ids = Image.where(analyzed: true).sample(5).pluck(:id)
    matrices = get_matrices(ids: ids)
    assert_equal ids.sort, matrices.keys.sort
  end

  test "get matrices exclude specified ids" do
    seed_test_images
    all_ids = Image.where(analyzed: true).pluck(:id)
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

  test "get matrices returns expected format" do
    seed_test_images
    Image.create # create blank image; should not exist in matrices
    matrices = get_matrices
    is_correct_format = true
    matrices.each do |id, matrix|
      is_correct_format = false unless !matrix.nil? and matrix.class == Hash and 
        matrix[:matrix].class == Array and matrix[:hist].class == Array and
        matrix[:colorVar].class == Array and matrix[:size].class == Integer
      break unless is_correct_format
    end
    assert is_correct_format, "get_matrices returned incorrect format"
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
      is_int = false unless (sim.class == Float || sim.class == Integer)
      break unless is_int
    end
    assert is_int
  end

  test "calc similarities empty comparison matrix" do
    seed_test_images
    matrices = get_matrices

    begin
      sim_sums = calc_similarities([], matrices)
      assert false, "Should raise exception with empty comparison matrix"
    rescue
    end
  end

  test "calc similarities nil comparison matrix" do
    seed_test_images
    matrices = get_matrices

    begin
      sim_sums = calc_similarities(nil, matrices)
      assert false, "Should raise exception with nil comparison matrix"
    rescue
    end
  end

  test "calc similarities empty matrices" do
    seed_test_images
    id_comp = Image.where(analyzed: true).sample.id
    matrix = get_matrices(ids: [id_comp])[id_comp]
    sim_sums = calc_similarities(matrix, {})
    assert_equal({}, sim_sums)
  end

  test "calc similarities nil matrices" do
    seed_test_images
    id_comp = Image.all.sample.id
    matrix = get_matrices(ids: [id_comp])[id_comp]
    begin
      sim_sums = calc_similarities(matrix, nil)
      assert false, "Should raise exception with nil matrices"
    rescue
    end
  end

  test "filter hash with empty hash" do
    filtered = filter_hash({})
    assert_equal({}, filtered)
  end

  test "filter hash with nil hash" do
    begin
      filtered = filter_hash(nil)
      assert false, "Passing nil hash into filter_hash should raise exception"
    rescue
    end
  end

  test "filter hash with min size > hash size" do
    h = {a: 1, b: 2, c: 3}
    filtered = filter_hash(h, min_size: 10)
    assert_equal h.sort, filtered.sort
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

  test "get sorted images raises exception with empty attributes" do
    seed_test_images
    sorter = {}
    ids = Image.where(analyzed: true).all.sample(5).pluck(:id)
    ids.each { |id| sorter[id] = 0 }
    begin
      images = get_sorted_images sorter, []
      assert false, "Should raise exception with empty attributes list"
    rescue
    end
  end

  test "get sorted images raises exception with nil attributes" do
    seed_test_images
    sorter = {}
    ids = Image.where(analyzed: true).all.sample(5).pluck(:id)
    ids.each { |id| sorter[id] = 0 }
    begin
      images = get_sorted_images sorter, nil
      assert false, "Should raise exception with nil attributes list"
    rescue
    end
  end

  test "get sorted images raises exception with empty sorter" do
    seed_test_images
    sorter = {}
    begin
      images = get_sorted_images, sorter, [:id]
      assert false, "Should raise exception with empty sorter"
    rescue
    end
  end

  test "get sorted images raises exception with nil sorter" do
    begin
      images = get_sorted_images, nil, [:id]
      assert false, "Should raise exception with nil sorter"
    rescue
    end
  end

  test "get sorted images gets correct images" do
    seed_test_images
    sorter = {}
    ids = Image.where(analyzed: true).all.sample(5).pluck(:id)
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
        assert false, "Should not throw error"
      end

      begin
        image.date
        assert false, "Should throw error since 'date' is not an included attribute"
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