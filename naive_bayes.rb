#!/usr/bin/env ruby
require 'core_extensions'
require 'set'

class ClassInfo
	SMOOTHING_VALUE = 0.1		
	attr_reader :label, :words_freq, :total_num_terms, :num_examples

	def initialize label='no_label'
		@label =label
		@words_freq = {}
		@total_num_terms = 0
		@num_examples = 0
	end
		
	def add_words words
		words.each do |word|
			@words_freq[word] ||= 0
			@words_freq[word] += 1
			@total_num_terms += 1
		end
		@num_examples += 1
	end
	
	def num_uniq_terms_in_corpus total_num_uniq_terms
		num_terms_not_in_this_class = total_num_uniq_terms - @words_freq.keys.size
		@probability_denominator = @total_num_terms + ( num_terms_not_in_this_class * SMOOTHING_VALUE )		
	end

	def probability_of word
		raise "uninited?" unless @probability_denominator
		probability_numerator = @words_freq[word] || SMOOTHING_VALUE
		prob = probability_numerator / @probability_denominator
#puts "word=#{word} probability_numerator=#{probability_numerator} @probability_denominator=#{@probability_denominator} => prob=#{prob}"
		prob
	end

end

class NaiveBayesClassifier

	attr_reader :class_info

	def initialize			
		@class_info = {}
		@all_words_seen = Set.new
		@num_examples = 0
	end

	def train training_set
		# run training, keeping track of all unique words		
		training_set.each do |example|			
			@class_info[example.clazz] ||= ClassInfo.new example.clazz	
			@class_info[example.clazz].add_words example.words
			@all_words_seen += example.words
			@num_examples += 1
		end
		
		# inform each class info of uniq words, will be required for zero value calcs
		@class_info.values.each do |info|
			info.num_uniq_terms_in_corpus @all_words_seen.size
		end
	end

	def test test_set
		total = 0
		correct = 0
		test_set.each do |example|
			total += 1
			predicted = classify example.words
			correct += 1 if predicted == example.clazz
		end				
		correct.to_f / total
	end

	def known_words_from words
		words.select { |w| @all_words_seen.include? w }
	end

	def classify words
		max_prob = nil
		max_prob_classes = []

		known_words = known_words_from words
		@class_info.keys.each do |clazz|
			prob = probability_given known_words, @class_info[clazz]
			if prob == max_prob or max_prob==nil
				max_prob = prob
				max_prob_classes << clazz
			elsif prob > max_prob
				max_prob = prob
				max_prob_classes = [clazz]
			end
		end
		return max_prob_classes.first # even in case of more than one max this is an effective guess
	end

	def probability_given words, class_info
		prob = 0.0

		# class conditional word probabilities
		words = words.frequency_hash
		words.each do |word,freq|
			word_probability = class_info.probability_of word
			word_probability = (word_probability ** freq ) / freq.factorial
			word_probability = replace_with_min_seen_so_far_if_zero word_probability
			prob += Math.log word_probability
		end

		# class probability
		prob += Math.log probability_given_class class_info

		prob
	end

	def replace_with_min_seen_so_far_if_zero value
		if value == 0
			return @min_prob_seen_so_far ? @min_prob_seen_so_far : 0.0000001
		else
			@min_prob_seen_so_far ||= value
			@min_prob_seen_so_far = value if value < @min_prob_seen_so_far
			value
		end
	end

	def probability_given_class class_info
		class_info.num_examples.to_f / @num_examples
	end

end
