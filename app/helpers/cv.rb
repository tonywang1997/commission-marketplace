class Cv
	@matrix
	@other
	def initialize(matrix,other)
		@matrix = matrix
		@other = other
	end
	
	def sim
		x=sample(@matrix)
		y=sample(@other)
		diff = 0
		for i in 0..127
			for j in 0..127
				xrbg = [0, 0, 0]
				yrbg = [0, 0, 0]
				if x[i] and x[i][j]
					xrbg = dot(x[i][j])
				end
				if y[i] and y[i][j]
					yrbg = dot(y[i][j])
				end
				z=xrbg.zip(yrbg).map { |x, y| (y - x)**2 }
				diff += z.sum
			end
		end
		return diff
	end
	def sample(matrix)
		sMatrix=matrix.sample(128)
		asdf = []
		sMatrix.each {|x| asdf << x.sample(128)}
		return asdf
	end
	def to_rbg(input)
		ret = []
		ret << (input || 0)/(256**3)
		ret << (input || 0)/(256**2)%256
		ret << (input || 0)/256%256
		return ret
	end
	def dot(input)
		x=to_rbg(input)
		x.map{|x| x**2}
		return x
	end
	def colorVar
		x1=sample(@matrix)
		x2=sample(@other)
		y1=sample(@matrix.transpose)
		y2=sample(@other.transpose)
		x1Dist=x1.each_cons(2).map{|a,b| b-a}.sort!
		x2Dist=x2.each_cons(2).map{|a,b| b-a}.sort!
		y1Dist=y1.each_cons(2).map{|a,b| b-a}.sort!
		y2Dist=y2.each_cons(2).map{|a,b| b-a}.sort!
		
		if x1Dist.length > x2Dist.length
			while x1Dist.length > x2Dist.length do
				x2Dist >> 0
			end
		elsif x2Dist > x1Dist.length
			while x2Dist.length > x1Dist.length do
				x1Dist >> 0
			end
		end
		if y1Dist.length > y2Dist.length
			while y1Dist.length > y2Dist.length do
				y2Dist >> 0
			end
		elsif y2Dist > y1Dist.length
			while y2Dist.length > y1Dist.length do
				y1Dist >> 0
			end
		end
		
		xDif = x1Dist.zip(x2Dist).map{|x,y| (y-x)**2}
		yDif = y1Dist.zip(y2Dist).map{|x,y| (y-x)**2}
		tDist = 0
		xDif.each{|x| tDist+=x}
		yDif.each{|x| tDist+=x}
		return tDist
	end
end
	
	

		
		