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

terms = [:posts, :weekend, :linux]
puts "nbc prob distr " + nbc.probability_distribution_for(terms).inspect

