#!/usr/bin/env ruby
# little helper just to make stdout easier to read when debugging
STDIN.each do |line|
	line.gsub! /^http:\/\/www.perezhilton.com\/index.xml/, 'perez'
	line.gsub! /^http:\/\/www.theregister.co.uk\/excerpts.rss/, 'thereg'
	puts line
end
