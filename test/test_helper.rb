ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

module ImageTestHelper
  def seed_test_images(num=10)
    Image.destroy_all
    image_paths = Dir.glob('app/assets/images/**/*.png').sample(num)
    images_cols = [:id, :price, :date, :binary_matrix]

    image_paths.each do |path|
      image_info = Img.new(path).to_matrix
      price = rand(50000) / 100.0
      price = 5.0 if File.basename(path) == 'anime_and_manga_15.png'
      image = Image.new({
        price: price,
        date: Time.at(Time.now.to_f * rand).to_date,
        binary_matrix: MessagePack.pack(Img.sample(image_info[:matrix], 128)),
        r_hist: MessagePack.pack(image_info[:rHist]),
        b_hist: MessagePack.pack(image_info[:bHist]),
        g_hist: MessagePack.pack(image_info[:gHist]),
        color_var: MessagePack.pack(image_info[:colarVar]),
        analyzed: true,
      })
      image.file.attach({
        io: File.open(path),
        filename: File.basename(path),
        content_type: 'image/png',
      })
      if not image.file.attached?
        puts "ERROR: Failed to attach image #{File.basename(path)}"
      elsif not image.save
        puts "ERROR: Failed to save image #{File.basename(path)}"
        image.file.purge
      end
    end
  end
end

class ActionView::TestCase
  include ImageTestHelper
end
