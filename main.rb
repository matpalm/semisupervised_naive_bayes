#!/usr/bin/env ruby

require 'parser'
require 'naive_bayes'
require 'semi_supervised_naive_bayes'

def summary articles
	freq = Hash.new 0
	articles.each { |a| freq[a.main_class] += 1 }
	"#{articles.length} articles; freq=#{freq.inspect}"
end

# read articles
articles = []
Parser.new.articles_from_stdin do |a|
	articles << a 
end

# split into labelled / test / unlabelled
proportion_of_labelled = 0.1
proportion_of_test = 0.1
num_articles = articles.length
puts "#{num_articles} articles in total"
labelled = articles.slice!(0, proportion_of_labelled*num_articles)
test = articles.slice!(0, proportion_of_test*num_articles)
unlabelled = articles
puts "#labelled=#{summary labelled} "
puts "#test=#{summary test} "
puts "#unlabelled=#{summary unlabelled}"

=begin
puts "*"*20 + " BEFORE"
labelled.each { |l| puts "labelled #{l.to_s}" }
test.each { |l| puts "test #{l.to_s}" }
unlabelled.each { |ul| puts "unlablled #{ul.to_s}" }
puts 
=end

nbc = NaiveBayesClassifier.new
nbc.train labelled
puts "nb result #{nbc.test test}"

ssnbc = SemiSupervisedNaiveBayesClassifier.new
ssnbc.train labelled, unlabelled
puts "ssnb result #{ssnbc.test test}"

=begin
puts "*"*20 + " AFTER"
labelled.each { |l| puts "labelled #{l.to_s}" }
test.each { |l| puts "test #{l.to_s}" }
unlabelled.each { |ul| puts "unlablled #{ul.to_s}" }
puts 
=end
