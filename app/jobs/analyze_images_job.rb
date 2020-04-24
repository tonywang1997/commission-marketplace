class AnalyzeImagesJob < ApplicationJob
  queue_as :default

  def perform(image_ids, *args)
    images = Image.where('images.id IN (?)', image_ids).with_attached_file.all
    images.each do |image|
      if not image.analyzed
        image.file.open do |file|
          image_info = Img.new(file).to_matrix
          image.binary_matrix = MessagePack.pack(Img.sample(image_info[:matrix], 128))
          image.r_hist = MessagePack.pack(image_info[:rHist])
          image.b_hist = MessagePack.pack(image_info[:bHist])
          image.g_hist = MessagePack.pack(image_info[:gHist])
          image.color_var = MessagePack.pack(image_info[:colorVar])
          image.analyzed = true
          image.save
          puts '*****'
          puts "Image #{image.id} analyzed!"
          puts '*****'
        end
      end
    end
  end
end
