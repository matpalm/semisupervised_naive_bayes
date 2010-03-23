class SemiSupervisedNaiveBayesClassifier

	def train labelled_set, unlabelled_set
		make_new_classifier
		train_classifier_with labelled_set
		assign_probabilities_to unlabelled_set
		while not converged?
			make_new_classifier
			train_classifier_with labelled_set
			train_classifier_with unlabelled_set			
			assign_probabilities_to unlabelled_set
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

	def assign_probabilities_to unlabelled_set
		# assign new class based on classification
		@last_assigned_classes = @assigned_classes
		@assigned_classes = []
		unlabelled_set.each do |unlabelled_example|			
			old_class = unlabelled_example.clazz
			new_class = @nbc.classify unlabelled_example.words
			unlabelled_example.clazz = new_class

#			printf "unlabelled_example=#{unlabelled_example} old_class=#{old_class} new_class=#{new_class} "
#			printf "***" if old_class != new_class
#			printf "\n" 

			@assigned_classes << new_class
		end				
	end

	def converged?
		return false if @last_assigned_classes.nil?
		return @assigned_classes == @last_assigned_classes
	end

end
