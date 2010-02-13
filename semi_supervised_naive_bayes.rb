class SemiSupervisedNaiveBayesClassifier

	def train labelled_set, unlabelled_set
		train_classifier_with labelled_set
		while not converged?
			augment_classifier_with unlabelled_set
		end
	end

	def test test_set
	end

	def train_classifier_with labelled_set
		@nbc = NaiveBayesClassifier.new
		@nbc.train labelled_set
	end

	def converged?
		
	end

end
