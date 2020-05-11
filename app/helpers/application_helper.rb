module ApplicationHelper
  # given a search string, parse into tags and price range
  def parse_search_string search
    if search.nil? or search.empty?
      return {tags: [], price_range: []}
    end
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
    Image.with_ids(exclude, ids).where(analyzed: true).in_batches(of: batch_size) do |image_batch|
      image_batch.pluck(:id, :binary_matrix, :binary_hist, :color_var, :size).each do |id, binary_matrix, binary_hist, color_var, size|
        # check timed out
        if Process.clock_gettime(Process::CLOCK_MONOTONIC) - start >= timeout
          return matrices
        end
        # unpack matrix, hist, and color_var
        matrices[id] = {
          matrix: MessagePack.unpack(binary_matrix),
          hist: MessagePack.unpack(binary_hist),
          colorVar: MessagePack.unpack(color_var),
          size: size,
        }
      end
    end
    matrices
  end

  def calc_similarities matrix_comp, matrices_db
    raise "Comparison matrix should not be nil or empty" if (matrix_comp.nil? || matrix_comp.empty?)
    raise "Matrices hash should not be nil" if matrices_db.nil?
    sim_sums = {}
    matrices_db.each do |id_db, matrix_db|
      sim_sums[id_db] = Cv.new(matrix_db, matrix_comp).sim
    end
    sim_sums
  end

  def filter_hash h, opts={}
    raise "Hash parameter in filter_hash should not be nil" if h.nil?
    max_val = opts[:max_val] || 100
    min_size = opts[:min_size] || 5
    filtered = h.filter { |id, val| val <= max_val }
    if filtered.size < min_size
      filtered = h.min(min_size) { |(akey, aval), (bkey, bval)| aval <=> bval }.to_h
    end
    filtered
  end

  def get_sorted_images sorter, attributes
    raise "Sorter should not be nil or empty" if (sorter.nil? || sorter.empty?)
    raise "Attributes list should not be nil or empty" if (attributes.nil? || attributes.empty?)
    Image.select(*attributes)
      .where('images.id IN (?)', sorter.keys)
      .sort do |a, b| 
        (sorter[a.id] || Float::INFINITY) <=> (sorter[b.id] || Float::INFINITY)
      end
  end
end
