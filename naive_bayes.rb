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
		
	def classify words
		max_prob = nil
		max_prob_class = []
		@class_info.keys.each do |clas|
			prob = probability_of_words_given_class words, clas
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

	def probability_of_words_given_class words, clas
		prob_fractions = conditional_probabilities_with_estimator_if_required words.uniq, clas
		prob_fractions.log_sum
	end

    def conditional_probabilities_with_estimator_if_required(words, clas)
        probabilities = conditional_probabilities(words,clas)
				#puts "probabilities=#{probabilities.inspect}"
        probabilities = probabilities.apply_estimator if probabilities.has_at_least_one_zero?
        probabilities
    end

    def conditional_probabilities(words, clas)
        words.collect { |word| conditional_probability(word, clas) }
    end

    def conditional_probability(word, clas)
				#puts ">conditional_probability word=#{word} clas=#{clas}"
        class_info = @class_info[clas]
				#puts "#{@class_info.keys.inspect}"
        return 0 unless class_info
        class_info.probability_of(word)
    end

end

		
