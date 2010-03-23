class Array
	def frequency_hash
		inject(Hash.new(0)) { |a,v| a[v]+=1; a }
	end
end

class Fixnum
	def factorial
		return 1 if self<=1
		return 2 if self==2
		@cached_fact ||= calc_fac
	end
	private
	def calc_fac 
		prod = 1
		self.times { |i| prod*=(i+1) }
		prod
	end
end
