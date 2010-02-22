require 'rational'

class Array
		
=begin
	def nominator
		self[0]
	end

	def denominator
		self[1]
	end
=end

	def normalize
		total = inject { |a,v| a+v }
		collect { |e| e.to_f / total }
		#raise "here"
	end

	def gcd a, b
		while b!=0
			tmp = b
			b = a % b
			a = tmp
		end
		return a
	end
			
	def lcm_pair a, b
		a*b / gcd(a,b)
	end
		
	def lcm 
		uniq.inject(1) { |a,b| lcm_pair(a,b) }
	end
	
	def has_at_least_one_zero?
		!!(find { |f| f.numerator==0 })
	end

	def has_at_least_one_one?
		!!(find { |f| f==Rational(1,1) })
	end

	def numerators 
		collect { |f| f.numerator }
	end

	def denominators 
		collect { |f| f.denominator }
	end
=begin

	def recalc_with_lcm
		lcm_across_fractions = denominators.lcm
		adjusted_numerators = collect do |fr| 
			num, denom = fr
			num_modifier = lcm_across_fractions / denom
			num * num_modifier
		end
		[adjusted_numerators, lcm_across_fractions]
	end
=end
	
	def apply_estimator!
		# numerators, denominator = recalc_with_lcm # NOT REQUIRED FOR CASE OF P(x|read) since all have same denominator
		denominator = first.denominator
		replace numerators.collect { |n| Rational(n+1, denominator+numerators.length) }		
	end

	def product
		product = inject do |v,a| 
			puts "product!! v=#{v.inspect} a=#{a.inspect} v*a=#{v*a} (v*a).reduce_precision=#{(v*a).reduced_precision}"
			(v*a).reduced_precision
		end
		puts "product of #{self.inspect} is #{product.inspect}"
		product
=begin
		numerator = denominator = 1
		each do |nd|
			n,d = nd
			numerator *= n
			denominator *= d
		end
		[ numerator, denominator ]
=end
	end
	
	def normalized_proportions!
		puts "PRE  normalisation #{self.inspect}"
		sum = inject{|v,a| v+a}
		replace collect{|n| n/sum }
		puts "POST normalisation #{self.inspect}"		
=begin
		denominator_lcm = denominators.lcm
#		puts "denominators=#{denominators.inspect}"
		numerator_multipliers = denominators.collect { |d| denominator_lcm / d }
		new_numerators = numerators.zip(numerator_multipliers).collect { |a| a[0]*a[1] }		
		replace new_numerators.normalize
=end
	end

	def reduce_precision!
		puts "PRE  reduce_precision #{self.inspect}"
		replace collect {|n| n.reduced_precision }
		puts "POST reduce_precision #{self.inspect}"
	end

	def make_just_zeros_and_one_if_required!
		puts "PRE  make_just_zeros_and_one_if_required! #{self.inspect}"
		replace collect { |n| n==Rational(1,1) ? n : Rational(0,1) } if has_at_least_one_one?
		puts "POST  make_just_zeros_and_one_if_required! #{self.inspect}"
	end

	def assert_is_fraction testee=self
		raise "expected array to represent a fraction, not #{testee.inspect}" unless testee.length==2
	end

	def mean_square_error other
		raise "require same length" unless length==other.length
		total_square_error = 0.0
		(0...length).each do |idx|
			diff = (self[idx] - other[idx]).abs
			total_square_error += diff * diff
		end
		total_square_error / length
	end
end

class Rational

	def reduced_precision
		return self if numerator < 1e10 && denominator < 1e10
		to_return = self.reduced_numerator_precision
		to_return = to_return.reduced_denominator_precision
		to_return # < 1e200 ? Rational(1,1e200.to_i) : to_return
	end

	def reduced_numerator_precision
		if numerator > 1e10
			divisor = numerator / 1e10
			puts "@@@reduced_numerator_precision numerator=#{numerator} denominator=#{denominator}"
			Rational((numerator/divisor).to_i, (denominator/divisor).to_i)
		else
			self		
		end
	end

	def reduced_denominator_precision
		if denominator > 1e10
			Rational(1, denominator/numerator)
		else
			self
		end
	end

end
