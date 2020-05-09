module ApplicationHelper
  # given a search string, parse into tags and price range
  def parse_search_string search
    price_range_regex = /\A\$?(\d*(?:\.\d*)?)-\$?(\d*(?:\.\d*)?)\Z/
    price_range = []
    tags = []
    search.split(' ').each do |word|
      match_data = price_range_regex.match word
      if match_data
        # ignore if price range already found
        if price_range.empty?
          # lower limit
          if match_data.captures[0] == ''
            price_range.push(0)
          else
            price_range.push(match_data.captures[0].to_f)
          end
          # upper limit
          if match_data.captures[1] == ''
            price_range.push(Float::INFINITY)
          else
            price_range.push(match_data.captures[1].to_f)
          end
        end
      else
        tags |= [word.downcase]
      end
    end
    {tags: tags, price_range: price_range}
  end

  def get_matrices opts={}
    exclude = opts[:exclude] || false
    ids = opts[:ids]
    timeout = opts[:timeout] || 30
    batch_size = opts[:batch_size] || 50
    
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    matrices = {}
    Image.with_ids(exclude, ids).in_batches(of: batch_size) do |image_batch|
      image_batch.pluck(:id, :binary_matrix).each do |id, binary_matrix|
        # check timed out
        if Process.clock_gettime(Process::CLOCK_MONOTONIC) - start >= timeout
          return matrices
        end
        # unpack matrix
        if binary_matrix
          matrices[id] = MessagePack.unpack(binary_matrix)
        end
      end
    end
    matrices
  end

  def calc_similarities matrix_comp, matrices_db
    sim_sums = {}
    matrices_db.each do |id_db, matrix_db|
      sim_sums[id_db] = Cv.new(matrix_db, matrix_comp).sim
    end
    sim_sums
  end

  def filter_hash h, opts={}
    max_val = opts[:max_val] || 100
    min_size = opts[:min_size] || 5
    filtered = h.filter { |id, val| val <= max_val }
    if filtered.size < min_size
      filtered = h.min(min_size) { |(akey, aval), (bkey, bval)| aval <=> bval }.to_h
    end
    filtered
  end

  def get_sorted_images sorter, attributes
    Image.select(*attributes)
      .where('images.id IN (?)', sorter.keys)
      .sort do |a, b| 
        (sorter[a.id] || Float::INFINITY) <=> (sorter[b.id] || Float::INFINITY)
      end
  end
end
