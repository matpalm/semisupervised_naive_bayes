#!/usr/bin/env ruby
require 'core_extensions'
require 'set'

class ClassInfo
	SMOOTHING_VALUE = 0.1		
	attr_reader :label, :words_freq, :total_num_terms, :num_examples

	def initialize label
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
		return 0 unless @probability_denominator
		probability_numerator = @words_freq[word] || SMOOTHING_VALUE
#		puts "word=#{word} probability_numerator=#{probability_numerator} @probability_denominator=#{@probability_denominator}"
		probability_numerator / @probability_denominator
	end

	def known_words_from words
		words.select { |w| @words_freq.keys.include? w }
	end

end

class NaiveBayesClassifier

	attr_reader :class_info

	def initialize			
		@class_info = {}
		@all_words_seen = Set.new
		@num_examples = 0
	end

=begin
	def known_classes
		@class_info.keys
	end
=end

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
#			puts "predicted=#{predicted} actual=#{example.clazz} total=#{total} correct=#{correct}"
		end				
		correct.to_f / total
	end

	def classify words
		max_prob = nil
		max_prob_classes = []

		@class_info.keys.each do |clazz|
			prob = probability_given words, @class_info[clazz]
			if prob == max_prob or max_prob==nil
				max_prob = prob
				max_prob_classes << clazz
			elsif prob < max_prob
				max_prob = prob
				max_prob_classes = [clazz]
			end
		end
		return max_prob_classes.first # even in case of more than one max this is an effective guess
	end

	def probability_given words, class_info
		prob = 0.0

		# class conditional word probabilities
		known_words = class_info.known_words_from words
		known_words = known_words.frequency_hash
#		puts "known_words (hash) = #{known_words.inspect}"
		known_words.each do |word,freq|
#			puts "calc for word #{word}"
			word_probability = class_info.probability_of word
#			puts "base prob = #{word_probability}"
#			puts "word freq = #{freq}; word freq! = #{freq.factorial}"
			word_probability = (word_probability ** freq ) / freq.factorial
#			puts "word #{word} multinominal freq = #{word_probability}; log = #{Math.log(word_probability)}"
			prob += Math.log word_probability
		end

		# class probability
#		puts "prob given class = #{probability_given_class class_info}; log = #{Math.log(probability_given_class class_info)}"
		prob += Math.log probability_given_class class_info

#		puts "FINAL prob for #{class_info.label} = #{prob}; Exp'd = #{Math.exp(prob)}"
		prob
	end

	def probability_given_class class_info
		class_info.num_examples.to_f / @num_examples
	end

=begin
# --------------------

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
=end

end

		
