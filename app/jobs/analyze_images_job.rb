class AnalyzeImagesJob < ApplicationJob
  queue_as :default

  def perform(image_ids, *args)
    raise "Array of image IDs should not be nil" if image_ids.nil?
    return if image_ids.empty?
    
    images = Image.where('images.id IN (?)', image_ids).with_attached_file.all
    images.each do |image|
      if !image.analyzed and image.file.attached?
        image.file.open do |file|
          image_info = Img.new(file).to_matrix
          # todo put all this into a helper
          image.binary_matrix = MessagePack.pack(Cv.dot_matrix(Img.sample(image_info[:matrix], 128)))
          image.binary_hist = MessagePack.pack(image_info[:hist])
          image.color_var = MessagePack.pack(image_info[:colorVar])
          image.size = image_info[:size]
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
