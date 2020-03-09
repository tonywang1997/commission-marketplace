require 'yaml'

class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_session_params, only: :home

  def home
    @images = create_placeholder_array

    @sort = (sort_options.include? params[:sort].downcase) ? params[:sort].downcase : 'none'
    @asc = (dir_options.key? params[:dir]) ? dir_options[params[:dir].downcase] : true
    if @sort == 'none'
      @images = @images.shuffle
    else
      # todo use later: Image.order(params[:sort] => :asc).limit(100)
      @images = sort_by(@images, @sort, @asc)
    end

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
    end

    def sort_options
      ['none', 'date', 'price']
    end
    
    def dir_options
      {'asc' => true, 'desc' => false}
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
                date: Time.at(Time.now.to_f * rand),
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
