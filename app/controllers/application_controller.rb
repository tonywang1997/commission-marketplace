require_relative '../helpers/img'
require_relative '../helpers/cv'
require 'set'

class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_session_params, only: :home

  def home
    action_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    @sort = (sort_options.include? params[:sort].downcase) ? params[:sort].downcase : 'none'
    @dir = (dir_options.include? params[:dir].downcase) ? params[:dir].downcase : 'asc'
    @tags = session[:tags]
    @price_range = session[:price_range]
    @image_tags = Image.tags
    @image_portfolios = Image.portfolios

    # sort by similarity
    if params[:sim_sort] and params[:sim_sort].to_i.to_s == params[:sim_sort]
      # calculate matrix for comparison image
      # todo put analyzed attribute in image table
      puts '*****'
      sort_start = Time.now
      @sort = nil
      @dir = nil
      @images = Image.in_price_range(@price_range).
                tagged(@tags).with_attached_file
      puts 'Retrieving comparison matrix:'
      start = Time.now
      id_comp = params[:sim_sort].to_i
      image_comp = Image.find_by(id: id_comp)
      matrix_comp = nil
      if image_comp and image_comp.analyzed
        matrix_comp = MessagePack.unpack(image_comp.binary_matrix)
      end

      if matrix_comp
        puts "\t#{id_comp}: #{matrix_comp.first[0..5]}"
        puts "Retrieved comparison matrix in: #{Time.now - start} s."

        # split up db calls into smaller chunks
        puts "Retrieving DB image matrices:"
        start = Time.now
        id_matrix_array = []
        @images.pluck(:id).each_slice(50).each do |slice|
          if (Process.clock_gettime(Process::CLOCK_MONOTONIC) - action_start) > 15
            break
          end
          id_matrix_array += Image.where('images.id IN (?)', slice).pluck(:id, :binary_matrix)
        end
        puts "Retrieved DB image matrices in: #{Time.now - start} s."

        # for each image, calculate its sim with comparison image and sum
        puts "Unpacking DB image matrices:"
        start = Time.now
        sim_sums = {}
        matrices_db = {}
        id_matrix_array.each do |image_db_id, binary_matrix|
          if image_db_id != id_comp and binary_matrix
            matrix_db = MessagePack.unpack(binary_matrix)
            puts "\t#{image_db_id}: #{matrix_db.first[0..5]}"
            matrices_db[image_db_id] = matrix_db
          end
        end
        puts "Unpacked DB image matrices in: #{Time.now - start} s."

        puts "Calculating sim values:"
        start = Time.now
        matrices_db.keys.each do |image_db_id|
          puts "\tAnalyzing #{image_db_id}"
          matrix_db = matrices_db[image_db_id]
          sim_sums[image_db_id] = Cv.new(matrix_db, matrix_comp).sim
        end
        sim_sums[id_comp] = 0
        puts "Calculated sim values in: #{Time.now - start} s."
        puts sim_sums

        # sort by sum of similarity values
        filtered_ids = sim_sums.keys.filter { |id| sim_sums[id] < 550000000 }
        if filtered_ids.size < 5
          filtered_ids = sim_sums.keys.min(5) { |a, b| sim_sums[a] <=> sim_sums[b] }
        end
        @images = @images.select(:id, :price, :date).
          where('images.id IN (?)', filtered_ids).
          sort do |a, b| 
            (sim_sums[a.id] || Float::INFINITY) <=> (sim_sums[b.id] || Float::INFINITY)
          end
        puts "Completed similarity sort in #{Time.now - sort_start} s."
        puts '*****'
      else
        puts "Failed to retrieve comparison matrix!"
      end
    elsif @sort == 'none'
      @images = Image.in_price_range(@price_range).
                      tagged(@tags).with_attached_file.all.shuffle
    else
      @images = Image.in_price_range(@price_range).tagged(@tags).
                      order(params[:sort] => @dir).with_attached_file.all
    end

    @hidden_images = Image.select(:id, :price, :date).where('images.id NOT IN (?)', @images.pluck(:id)).with_attached_file

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

    def set_session_params
      params[:sort] ||= (session[:sort] ||= 'none')
      session[:sort] = params[:sort]

      params[:dir] ||= (session[:dir] ||= 'asc')
      session[:dir] = params[:dir]

      params[:search] ||= (session[:search] ||= '')
      session[:search] = params[:search]
      session[:tags] = []
      session[:price_range] = []

      price_range_regex = /\A\$?(\d*(?:\.\d*)?)-\$?(\d*(?:\.\d*)?)\Z/
      params[:search].split(' ').each do |tag|
        md = price_range_regex.match tag
        if md and session[:price_range].empty?
          # lower limit
          if md.captures[0] == ''
            session[:price_range].push(0)
          else
            session[:price_range].push(md.captures[0].to_f)
          end
          # upper limit
          if md.captures[1] == ''
            session[:price_range].push(Float::INFINITY)
          else
            session[:price_range].push(md.captures[1].to_f)
          end
        else
          session[:tags] |= [tag.downcase]
        end
      end

      puts '*****'
      p session[:tags]
      p session[:price_range]
      puts '*****'
    end

    def sort_options
      ['none', 'date', 'price', 'sim']
    end
    
    def dir_options
      ['asc', 'desc']
    end

    def sort_by(image_array, attribute, asc=true)
      image_array.sort! do |x, y|
        if asc
          x[attribute.to_sym] <=> y[attribute.to_sym]
        else
          y[attribute.to_sym] <=> x[attribute.to_sym]
        end
      end

      image_array
    end

    def create_placeholder
      width = rand(3999) + 1
      height = rand(3999) + 1
      bg_color = "%06x" % (rand * 0xffffff)
      return  { url: "https://via.placeholder.com/#{width}x#{height}/#{bg_color}/000000",
                artist: "Artist_#{rand(4000)}",
                portfolio: "Portfolio_#{rand(4000)}",
                price: rand(4000),
                width: width,
                height: height,
                date: Time.at(Time.now.to_f * rand).to_date,
              }
    end

    def create_placeholder_array
      # placeholders = []
      # (0...100).each do |id|
      #   ph = create_placeholder
      #   ph[:id] = id
      #   placeholders.push(ph)
      # end
      # File.open('app/assets/images/placeholders.txt', 'w') do |file|
      #   file.write(placeholders.to_yaml)
      # end
      # placeholders
      YAML.load(File.read('app/assets/images/placeholders.txt'))
    end
end
