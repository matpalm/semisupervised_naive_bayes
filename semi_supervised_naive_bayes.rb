class SemiSupervisedNaiveBayesClassifier

	def train labelled_set, unlabelled_set
		make_new_classifier
		train_classifier_with labelled_set
		record_all_distrinct_classes
		assign_probability_distribution_to unlabelled_set
		while not converged?
			make_new_classifier
			train_classifier_with labelled_set
			train_classifier_with unlabelled_set			
			assign_probability_distribution_to unlabelled_set
		end
	end

	def test test_set
		@nbc.test test_set
	end

	def make_new_classifier
		@nbc = NaiveBayesClassifier.new
	end
		
	def train_classifier_with set
		@nbc.train set
	end

	def record_all_distrinct_classes
		# we do this once to ensure same order from now onwards..
		@all_classes = @nbc.known_classes
	end

	def assign_probability_distribution_to unlabelled_set
		# assign new probability distribution
		unlabelled_set.each do |unlabelled_example|
			new_prob_distr = @nbc.probability_distribution_for unlabelled_example.words
			unlabelled_example.probability_distribution = new_prob_distr
		end				
		
		# record all new probabilities in single array for later convergence checking
		@last_all_unlabelled_probabilities = @all_unlabelled_probabilities
		@all_unlabelled_probabilities = []
		unlabelled_set.each do |unlabelled_example|
			@all_classes.each do |clazz|
				@all_unlabelled_probabilities << unlabelled_example.probability_distribution[clazz]
			end
		end	
	end

	def converged?
		return false if @last_all_unlabelled_probabilities.nil?
		mean_square_error = @last_all_unlabelled_probabilities.mean_square_error @all_unlabelled_probabilities
		puts "converged? check -> mean_square_error=#{mean_square_error}"		
		mean_square_error < 0.0001
	end

end
