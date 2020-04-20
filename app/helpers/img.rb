
class Img

	@image
	def initialize(imginfo, options = {})
		# if options[:binary] == true, imginfo contains blob string
		# if options[:rgba] == true, imginfo contains rgba pixel stream
		# if options[:io] == true, imginfo contains IO object
		# else, imginfo contains file path
		if options[:binary]
			@image = ChunkyPNG::Image.from_blob(imginfo)
		elsif options[:rgba]
			@image = ChunkyPNG::Image.from_rgba_stream(options[:width], options[:height], imginfo)
		elsif options[:io]
			@image = ChunkyPNG::Image.from_io(imginfo)
		else
			@image = ChunkyPNG::Image.from_file(imginfo)
		end
	end

	def to_rbg(input)
		ret = []
		ret << input/(256**3)
		ret << input/(256**2)%256
		ret << input/256%256
		return ret
	end
	def getMatrix
		return @image
	end
	def to_matrix
		x=[]
		for i in 0..@image.height-1
			x << Array(@image.row(i))
		end
		return x
	end
	def sample(matrix)
		sMatrix=matrix.sample(128)
		asdf = []
		sMatrix.each {|x| asdf << x.sample(128)}
		return asdf
	end

	def height
		@image.dimension.height
	end

	def width
		@image.dimension.width
	end

	def to_rgba_stream
		@image.to_rgba_stream
	end
end	
	




# x=Img.new('chunk.png')
# y=x.getMatrix
# puts y.column(0).class
# z=Array(y.column(0))
# puts z.class
# asdf=x.to_matrix
# asdf2=x.sample(asdf)
# puts asdf2.length
# puts asdf2[2].length




