class AnalyzeImagesJob < ApplicationJob
  queue_as :default

  def perform(image_ids, *args)
    images = Image.where('images.id IN (?)', image_ids).with_attached_file.all
    images.each do |image|
      if !image.analyzed and image.file.attached?
        image.file.open do |file|
          image_info = Img.new(file).to_matrix
          image.binary_matrix = MessagePack.pack(Img.sample(image_info[:matrix], 128))
          image.r_hist = MessagePack.pack(image_info[:rHist])
          image.b_hist = MessagePack.pack(image_info[:bHist])
          image.g_hist = MessagePack.pack(image_info[:gHist])
          image.color_var = MessagePack.pack(image_info[:colorVar])
          image.analyzed = true
          if image.save
            puts '*****'
            puts "Image #{image.id} analyzed!"
            puts '*****'
          else
            raise "Image could not be saved with errors: #{image.errors.messages}"
          end
        end
      end
    end
  end
end
