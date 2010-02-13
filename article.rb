class Article
	attr_reader :words
	attr_accessor :probability_distribution

	def initialize words, probability_distribution
		@words = words
		@probability_distribution = probability_distribution
	end

	def probability_of clazz
		@probability_distribution[clazz] || 0
	end

	def classes
		@probability_distribution.keys
	end

	def main_class		
		max_prob = nil
		max_prob_classes = []
		classes.each do |clas|
			prob = probability_of clas
			if prob == max_prob or max_prob==nil
				max_prob = prob
				max_prob_classes << clas
			elsif prob > max_prob
				max_prob = prob
				max_prob_classes = [clas]
			end
		end
		return max_prob_classes.first if max_prob_classes.length==1
		return :cant_decide	
	end

	def to_s
		"#{words[0,5].inspect} #{probability_distribution.inspect}"
	end

end
