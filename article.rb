class Article
	attr_reader :words

	def initialize words, class_weightings
		@words = words
		@class_weightings = class_weightings
	end

	def weight_for clazz
		@class_weightings[clazz] || 0
	end

	def classes
		@class_weightings.keys
	end

	def main_class		
		max_prob = nil
		max_prob_classes = []
		classes.each do |clas|
			prob = weight_for clas
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

end
