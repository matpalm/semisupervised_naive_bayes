class Article
	attr_reader :words
	attr_accessor :clazz

	def initialize words, clazz
		@words = words
		@clazz = clazz
	end

	def to_s
		"first_5_words=#{words[0,5].inspect} clazz=#{clazz}"
	end

end
