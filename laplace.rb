class Array
		
	def nominator
		self[0]
	end

	def denominator
		self[1]
	end

	def normalize
		total = inject { |a,v| a+v }
		collect { |e| e.to_f / total }
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
		!!(find { |f| f.nominator==0 })
	end

	def numerators 
		collect { |f| f.nominator }
	end

	def denominators 
		collect { |f| f.denominator }
	end

	def recalc_with_lcm
		lcm_across_fractions = denominators.lcm
		adjusted_numerators = collect do |fr| 
			num, denom = fr
			num_modifier = lcm_across_fractions / denom
			num * num_modifier
		end
		[adjusted_numerators, lcm_across_fractions]
	end
	
	def apply_estimator!
		# numerators, denominator = recalc_with_lcm # NOT REQUIRED FOR CASE OF P(x|read) since all have same denominator
		denominator = first.denominator
		replace numerators.collect { |n| [n+1, denominator+numerators.length] }		
	end

	def product
		numerator = denominator = 1
		each do |nd|
			n,d = nd
			numerator *= n
			denominator *= d
		end
		[ numerator, denominator ]
	end
	
	def normalized_proportions!
		denominator_lcm = denominators.lcm
		numerator_multipliers = denominators.collect { |d| denominator_lcm / d }
		new_numerators = numerators.zip(numerator_multipliers).collect { |a| a[0]*a[1] }		
		replace new_numerators.normalize
	end

	def assert_is_fraction testee=self
		raise "expected array to represent a fraction, not #{testee.inspect}" unless testee.length==2
	end

end
