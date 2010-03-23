#!/usr/bin/env ruby

require 'parser'
require 'naive_bayes'
require 'semi_supervised_naive_bayes'

raise "main.rb NUM_LABELLED NUM_TEST NUM_UNLABELLED1 NUM_UNLABELLED2 ..." unless ARGV.length>=3
num_labelled = ARGV.shift.to_i
num_test = ARGV.shift.to_i
num_unlabelleds = ARGV.collect { |n| n.to_i }

def summary articles
	freq = Hash.new 0
	articles.each { |a| freq[a.clazz] += 1 }
	"#{articles.length} articles; freq=#{freq.inspect}"
end

articles = []
Parser.new.articles_from_stdin do |a|
	articles << a 
end

total_num_articles = articles.length
puts "#{total_num_articles} articles in total"

labelled = articles.slice!(0, num_labelled)
test = articles.slice!(0, num_test)
puts "#labelled=#{summary labelled} "
puts "#test=#{summary test} "

nbc = NaiveBayesClassifier.new
nbc.train labelled

puts "nb result #{nbc.test test}"

num_unlabelleds.each do |num_unlabelled|
	unlabelled = articles.slice(0,num_unlabelled)
	puts "#unlabelled=#{summary unlabelled}"
	unlabelled.each { |a| a.clazz = nil } 	

	ssnbc = SemiSupervisedNaiveBayesClassifier.new
	ssnbc.train labelled, unlabelled
	puts "ssnb result (#{num_unlabelled}) #{ssnbc.test test}"

end


