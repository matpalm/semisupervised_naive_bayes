#!/usr/bin/env ruby
require 'laplace'
require 'set'

class ClassInfo
	attr_reader :count
	attr_reader :words_freq
	
	def initialize
		@count = 0
		@words_freq = {}
		@words_freq.default = 0
	end
		
	def add_words words, weight
		@count += weight
		words.uniq.each do |word|
			@words_freq[word] += weight
		end
	end
	
	def probability_of word
		[frequency_of(word), count]
	end

	private

	def frequency_of word
		@words_freq[word] ? @words_freq[word] : 0
	end

end

class NaiveBayesClassifier

	def initialize			
		@total_training_examples = 0		
		@class_info = {}
	end

	def train training_set
		training_set.each do |example|			
			@total_training_examples += 1
			example.classes.each do |clazz|
				@class_info[clazz] ||= ClassInfo.new		
				@class_info[clazz].add_words example.words, example.weight_for(clazz)
			end
		end
	end

	def test test_set
		total = 0
		correct = 0
		test_set.each do |example|
			total += 1
			predicted = classify example.words
			correct += 1 if predicted == example.main_class
			puts "example=#{example.words[0,5].inspect} predicted=#{predicted} actual=#{example.main_class} correct=#{correct} total=#{total}"
		end				
		correct.to_f / total
	end

	def classify words
		distribution = probability_distribution_for words
		max_prob = nil
		max_prob_classes = []
		distribution.each do |clas, prob|
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

	def probability_distribution_for words
		ordered_keys = @class_info.keys
		probs = ordered_keys.collect { |k| probability_of_class_given_words words, k }
#		puts "probs #{probs.inspect}"
		probs.normalized_proportions!
		distr = {}
		ordered_keys.zip(probs).each do |key_value|
			clas, prob = key_value
			distr[clas] = prob
		end
		distr
	end

	def probability_of_class_given_words words, clas
		p_terms = term_probabilities_given_class_with_estimator_if_required words.uniq, clas
		p_class = [ @class_info[clas].count, @total_training_examples]
		p_terms << p_class
		p_terms.product
	end

  def term_probabilities_given_class_with_estimator_if_required words, clas
		probabilities = term_probabilities_given_class words,clas
		probabilities.apply_estimator! if probabilities.has_at_least_one_zero?
		probabilities
  end

  def term_probabilities_given_class(words, clas)
    words.collect { |word| conditional_probability word, clas }
  end

  def conditional_probability(word, clas)
    class_info = @class_info[clas]
    return 0 unless class_info
    class_info.probability_of word
  end

end

		
