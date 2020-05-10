require 'chunky_png'

class Img

	@image
	def initialize(imgpath)
		@image = ChunkyPNG::Image.from_file(imgpath)
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
	#note to self, look into hashing like chunky does in order to drop the number of dimensions by 1
		triHist = Array.new(5){Array.new(5){Array.new(5,0)}}
		redHist=Array.new(6,0)
		blueHist=Array.new(6,0)
		greenHist=Array.new(6,0)
		x=[]
		variance=[]
		numPixels = @image.height*@image.width
		for i in 0..@image.height-1
			row=Array(@image.row(i))
			if i != 0
				row2=Array(@image.row(i-1))
				diff=row2.zip(row).map{|a,b| ChunkyPNG::Color.euclidean_distance_rgba(b,a)}.sort
				variance << median(diff)
			end	
			x << row
			row.each{|curr| 
				currRBG=to_rbg(curr)
				triHist[histLoc(currRBG[0])][histLoc(currRBG[1])][histLoc(currRBG[2])]+=1
			}
		end
		return {matrix: x, hist:triHist, size:numPixels, colorVar: variance}
	end
	def histLoc(color)
		loc=color/50
		if loc >4
			return 4
		else
			return loc
		end
	end
	def sample(matrix)
		sMatrix=matrix.sample(128)
		asdf = []
		sMatrix.each {|x| asdf << x.sample(128)}
		return asdf
	end
	def median(arr)
		if arr.length%2 != 0
			return arr[arr.length/2]
		else
			return (arr[arr.length/2]+arr[arr.length/2-1])/2.0
		end
	end
end	

#x= Img.new('asdf.png').to_matrix
#puts x[:hist].join(' ')
