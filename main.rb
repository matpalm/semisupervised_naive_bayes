#!/usr/bin/env ruby

require 'parser'
require 'naive_bayes'

# read articles
articles = []
Parser.new.articles_from_stdin do |a|
	a[:classification] = (a[:url] == 'http://www.perezhilton.com/index.xml'.to_sym ? :perez : :thereg)
	a.delete :url
	articles << a 
end

# split into labelled / unlabelled sets
proportion_of_labelled = 0.3
num_articles = articles.length
puts "#{num_articles} articles in total"
labelled = articles.slice!(0, proportion_of_labelled*num_articles)
unlabelled = articles
puts "#labelled=#{labelled.length} #unlabelled=#{unlabelled.length}"

nbc = NaiveBayesClassifier.new
nbc.train labelled
nbc.test unlabelled

#ssnbc = SemiSupervisedNaiveBayesClassifier.new
#ssnbc.
