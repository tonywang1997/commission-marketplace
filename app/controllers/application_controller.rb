require_relative '../helpers/img'
require_relative '../helpers/cv'
require 'set'

class ApplicationController < ActionController::Base
  include SessionsHelper
  include ApplicationHelper
  before_action :set_variables, only: :home

  def home
    # sort by similarity
    if @sim_sort and @sim_sort.to_i.to_s == @sim_sort
      @sort = nil
      @dir = nil
      # todo keep existing filters (price range and tags)
      # retrieve comparison matrix
      id_comp = @sim_sort.to_i
      matrix_comp = get_matrix(id_comp)
      # todo handle properly/disable button
      raise "Failed to retrieve comparison matrix!" unless matrix_comp
      if matrix_comp
        # split up db calls into smaller chunks
        matrices_db = get_matrices(id_comp, batch_size: 50, timeout: 15)
        # for each image, calculate its sim with comparison image and sum
        sim_sums = calc_similarities(matrix_comp, matrices_db)
        sim_sums[id_comp] = 0 # similarity with self is 0
        # sort and filter by sum of similarity values
        filtered_sim_sums = filter_hash(sim_sums, max_val: 550000000, min_size: 5)
        @images = get_sorted_images(filtered_sim_sums, [:id, :price, :date])
      end
    elsif @sort == 'none'
      @images = Image.in_price_range(@price_range).tagged(@tags)
                  .order("RANDOM()").with_attached_file
    else
      @images = Image.in_price_range(@price_range).tagged(@tags)
                  .order(@sort => @dir).with_attached_file
    end

    @hidden_images = Image.select(:id, :price, :date).where('images.id NOT IN (?)', @images.pluck(:id)).with_attached_file

    respond_to do |format|
      format.html
      format.js
    end
  end

  # helper methods
  # todo put these somewhere else - PORO?

  private

    def set_variables
      @image_tags = Image.tags
      @image_portfolios = Image.portfolios

      @sort = params[:sort] || 'none'
      @sort = (sort_options.include? @sort.downcase) ? @sort.downcase : 'none'

      @dir = params[:dir] || 'asc'
      @dir = (dir_options.include? @dir.downcase) ? @dir.downcase : 'asc'

      @search = params[:search] || ''
      @sim_sort = params[:sim_sort]
      parsed = parse_search_string(@search)
      @tags = parsed[:tags]
      @price_range = parsed[:price_range]
    end

    def sort_options
      ['none', 'date', 'price']
    end
    
    def dir_options
      ['asc', 'desc']
    end

end
