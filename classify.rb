#!/usr/bin/env ruby

require 'parser'
require 'naive_bayes'

articles = []
Parser.new.articles_from_stdin do |a|
	a[:classification] = a[:url]
	articles << a 
end

nbc = NaiveBayesClassifier.new
articles.each do |article|
	nbc.train article[:words], article[:classification]
end

terms = [:website, :on, :hollywood]
puts nbc.classify terms

terms = [:website, :on, :linux]
puts nbc.classify terms

=begin

classifiers = []
#classifiers << MAlgoClassifier.new
#classifiers << WordOccClassifier.new
#classifiers << NaiveBayesClassifier.new
classifiers << MultinominalBayesClassifier.new
#classifiers << MarkovChainClassifier.new(:include_start_end => true)
classifiers << VectorSpaceModel.new

crossvalidators = classifiers.collect { |classifier| CrossValidator.new(classifier, slice.to_i, num_slices.to_i) }

articles.each_with_index do |article, idx|
	crossvalidators.each do |crossvalidator|
		crossvalidator.training_pass idx, article	
	end
end
articles.each_with_index do |article, idx|
	crossvalidators.each do |crossvalidator|
		crossvalidator.testing_pass idx, article	
	end
end

crossvalidators.each do |crossvalidator|
	classifier = crossvalidator.classifier
	display_name = classifier.respond_to?(:display_name) ? classifier.display_name : classifier.class.to_s
	puts "result #{display_name} #{crossvalidator.pass_rate}"
end
=end
