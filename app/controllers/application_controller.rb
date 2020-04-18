require 'yaml'
require_relative '../helpers/img'
require_relative '../helpers/cv'

class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_session_params, only: :home

  def home
    @sort = (sort_options.include? params[:sort].downcase) ? params[:sort].downcase : 'none'
    @dir = (dir_options.include? params[:dir].downcase) ? params[:dir].downcase : 'asc'
    @tags = session[:tags]

    if @tags.any?
      if @sort == 'none'
        @images = Image.tagged(@tags).shuffle
      else
        @images = Image.tagged(@tags).order(params[:sort] => @dir).limit(100)
      end
    else
      if @sort == 'none'
        @images = Image.select(:id, :price, :date).all.shuffle
      elsif @sort == 'sim' and params[:files]
        # calculate matrices for each attached file
        matrices_att = []
        params[:files].each do |file_param|
          image = Image.new(file: file_param)
          image.file.open do |file_att|
            matrices_att.push(Img.new(file_att.path).to_matrix)
          end
        end

        puts '*****'
        p matrices_att.first.first[0..5]

        # for each image, calculate its sim with each attachment and average
        sim_sums = {}
        @images = Image.all
        @images.each_with_index do |image_db, idx|
          sim_sums[image_db.id] = 0
          matrices_att.each do |matrix_att|
            if image_db.matrix and image_db.matrix.size > 0
              puts "id: #{image_db.id}"
              p image_db.matrix.first[0..5]
              sim_sums[image_db.id] += Cv.new(image_db.matrix, matrix_att).sim
            end
          end
        end

        puts sim_sums
        puts '*****'

        @images = @images.sort { |a, b| sim_sums[a.id] <=> sim_sums[b.id] }
      else
        @images = Image.select(:id, :price, :date).order(params[:sort] => @dir).limit(100)
        # @images = sort_by(@images, @sort, @asc)
      end
    end
    
    @hidden_images = Image.select(:id, :price, :date).all - @images

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

      params[:search] ||= (session[:tags] ||= []).join(' ')
      session[:tags] = params[:search].split(' ')

      puts '*******'
      puts session[:tags]
      puts '*******'
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
