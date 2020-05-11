require_relative 'img'
require 'chunky_png'

class Cv
	@matrix
	@other
	@hist1
	@hist2
	@var1
	@var2
	@dims1
	@dims2
	def initialize(img1,other)
		@matrix = img1[:matrix]
		@other = other[:matrix]
		@hist1 = img1[:hist]
		@hist2 = other[:hist]
		@var1=img1[:colorVar]
		@var2=other[:colorVar]
		@dims1=img1[:size].to_f
		@dims2=other[:size].to_f
	end
	
	def sim
		return Math.sqrt(histDiff+colorVar**2+gramDiff)
	end
	
	def colorVar
		v1 = @var1
		v2 = @var2
		x = v1.zip(v2).map{|x,y| ((y || 0)-(x || 0))**2}	
		return x.sum
	end
	
	def histDiff
		h1 = @hist1
		h2 = @hist2
		diff = 0
		for i in 0..4
			for j in 0..4
				for k in 0..4
					bucket1 = h1[i][j][k]
					bucket2 = h2[i][j][k]
					if bucket1+bucket2 != 0
						diff += (bucket1-bucket2)**2/(bucket1+bucket2)
					end
					#print bucket1
					#print ' '
					#print bucket2
					#puts ''
				end
			end
		end
		return diff
	end
	
	def gramDiff
		x=@matrix
		y=@other
		diff = 0
		for i in 0..127
			for j in 0..127
				xrbg = [0, 0, 0]
				if !(x[i].nil? || x[i][j].nil?)
					xrbg = x[i][j]
				end

				yrbg = [0, 0, 0]
				if !(y[i].nil? || y[i][j].nil?)
					yrbg = y[i][j]
				end
				
				z=xrbg.zip(yrbg).map { |x, y| (y - x)**2 }
				diff += z.sum
			end
		end
		return diff
	end
	def self.to_rbg(input)
		ret = []
		ret << (input || 0)/(256**3)
		ret << (input || 0)/(256**2)%256
		ret << (input || 0)/256%256
		return ret
	end
	def self.dot(input)
		x=to_rbg(input)
		x.map{|x| x**2}
		return x
	end

	def self.dot_matrix(matrix)
		dotted_matrix = []
		matrix.each do |row|
			dotted_row = []
			row.each do |elt|
				dotted_row.push(dot(elt))
			end
			dotted_matrix.push(dotted_row)
		end
		dotted_matrix
	end
	#def subt(first, second)
	#	x1 = to_rbg(first)
	#	x2 = to_rbg(second)
	#	totalDif = x1.zip(x2).map{|x,y| (y-x)**2}
	#	return totalDif.sum
	#end	
end



#x= Img.new('asdf.png').to_matrix
#y=Img.new('pixel1.png').to_matrix
#z=CV.new(x,y)
#puts Math.sqrt(z.gramDiff), 'gram'
#puts Math.sqrt(z.colorVar), 'var'
#puts z.sim, 'hist'
#puts "finish"


		
		