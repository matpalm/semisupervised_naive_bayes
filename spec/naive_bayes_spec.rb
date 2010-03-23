require File.dirname(__FILE__) + '/../naive_bayes'

describe 'class info' do

	before :each do
		@ci = ClassInfo.new
	end
		
	describe 'trained with no data' do
		
		it 'should report it has seen no examples' do
			@ci.num_examples.should == 0
		end

	end

	describe 'trained with 1 word from a 1 word corpus' do

		before :each do
			@ci.add_words [ :a ]
		end
		
		it 'should report 1.0 probability for the word' do
			@ci.num_uniq_terms_in_corpus 1
			@ci.probability_of(:a).should == 1.0
		end

		it 'should report it has seen one example' do
			@ci.num_examples.should == 1
		end

	end

	describe 'trained with 1 word from a 2 word corpus' do
		
		before :each do
			@ci.add_words [ :a ]
			@ci.num_uniq_terms_in_corpus 2
		end

		it 'should report close to 1.0 probability for the trained word' do
			@ci.probability_of(:a).should == 1.0 / 1.1
		end

		it 'should report close to 0.0 probability for the any other word' do
			@ci.probability_of(:b).should == 0.1 / 1.1
		end

	end

	describe 'trained with 1 word appearing twice ' do

		before :each do
			@ci.add_words [ :a, :a ]
		end

		it 'should report 1.0 probability for the trained word from a 1 word corpus' do
			@ci.num_uniq_terms_in_corpus 1
			@ci.probability_of(:a).should == 1.0
		end

		it 'should report close to 1.0 probability for the trained word from a 2 word corpus' do
			@ci.num_uniq_terms_in_corpus 2
			@ci.probability_of(:a).should == 2.0 / 2.1
		end

	end

	describe 'trained with 1 word appearing thrice from a 3 word corpus' do

		it 'should report close to 1.0 probability for the trained word' do
			@ci.add_words [ :a, :a, :a ]
			@ci.num_uniq_terms_in_corpus 3
			@ci.probability_of(:a).should == 3.0 / 3.2
		end

	end

	describe 'trained with 2 words from a 3 word corpus' do

		describe 'with one example' do
	
			before :each do
				@ci.add_words [ :a, :a, :a, :b, :b ]
			end

			it 'should report close to 1.0 probability for the trained word' do
				@ci.num_uniq_terms_in_corpus 3
				@ci.probability_of(:a).should == 3.0 / 5.1
				@ci.probability_of(:b).should == 2.0 / 5.1
			end

			it 'should correctly identify words that it hasnt seen' do
				@ci.known_words_from([:a, :c, :b, :a, :d]).should == [:a, :b, :a]
			end

			it 'should report it has seen one example' do
				@ci.num_examples.should == 1
			end

		end

		describe 'across two examples' do
			before :each do
				@ci.add_words [ :a, :a, :b ]
				@ci.add_words [ :a, :b ]
			end

			it 'should report the same probability as single example case' do
				@ci.num_uniq_terms_in_corpus 3
				@ci.probability_of(:a).should == 3.0 / 5.1
				@ci.probability_of(:b).should == 2.0 / 5.1
			end

			it 'should report it has seen two examples' do
				@ci.num_examples.should == 2
			end

		end

	end
end

describe 'naive bayes' do

	before :each do
		@naive_bayes = NaiveBayesClassifier.new
	end

	describe 'while keeping track of the minimum prob seen so far' do
		it 'should return 0.0000001 for zero before seeing any other value' do
			@naive_bayes.replace_with_min_seen_so_far_if_zero(0).should == 0.0000001
		end
		it 'should return value if not zero and first value seen and that value if zero seen' do
			@naive_bayes.replace_with_min_seen_so_far_if_zero(0.3).should == 0.3
			@naive_bayes.replace_with_min_seen_so_far_if_zero(0).should == 0.3
		end
		it 'keep track of lowest value when given zero' do
			@naive_bayes.replace_with_min_seen_so_far_if_zero(0.3).should == 0.3
			@naive_bayes.replace_with_min_seen_so_far_if_zero(0.1).should == 0.1
			@naive_bayes.replace_with_min_seen_so_far_if_zero(0.2).should == 0.2
			@naive_bayes.replace_with_min_seen_so_far_if_zero(0).should == 0.1
		end
	end

end

