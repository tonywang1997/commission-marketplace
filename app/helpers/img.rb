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
		redHist=Array.new(6,0)
		blueHist=Array.new(6,0)
		greenHist=Array.new(6,0)
		x=[]
		variance=[]
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
				redHist[currRBG[0]/50]+=1	
				blueHist[currRBG[1]/50]+=1
				greenHist[currRBG[2]/50]+=1
			}
		end
		return {matrix: x, rHist: redHist, bHist: blueHist,gHist: greenHist, colorVar: variance}
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
