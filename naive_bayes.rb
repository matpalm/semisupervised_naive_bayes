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
		
	def add_words words
		@count += 1
		words.uniq.each do |word|
			@words_freq[word] += 1
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
		reset
	end

	def reset
		@total_training_examples = 0		
		@class_info = {}
	end
	
	def train(words, clas)		
		@total_training_examples += 1
		@class_info[clas] ||= ClassInfo.new		
		@class_info[clas].add_words(words)
	end
		
	def probability_distribution_for words
		ordered_keys = @class_info.keys
		probs = ordered_keys.collect { |k| probability_of_class_given_words words, k }
		probs.normalized_proportions!
		distr = {}
		ordered_keys.zip(probs).each do |key_value|
			clas, prob = key_value
			distr[clas] = prob
		end
		distr
	end

	def classify words
		distribution = probability_distribution_for words
		max_prob = nil
		max_prob_class = []
		distribution.each do |clas, prob|
			if prob == max_prob or max_prob==nil
				max_prob = prob
				max_prob_class << clas
			elsif prob > max_prob
				max_prob = prob
				max_prob_class = [clas]
			end
		end
		max_prob_class
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

		
