require 'article'
describe 'article' do

	it 'should store words' do
		article = Article.new [:a,:b,:c], nil
		article.words.should == [:a,:b,:c]
	end

	it 'should store class probabilities' do
		article = Article.new nil, { :a => 1.0, :b => 0.3 }
		article.weight_for(:a).should == 1.0
		article.weight_for(:b).should == 0.3
		article.classes.should == [:a,:b]
	end

	it 'should calculate main probability' do
		article = Article.new nil, { :a => 1.0, :b => 0.3 }
		article.main_class.should == :a
		article = Article.new nil, { :a => 0.1, :b => 0.3 }
		article.main_class.should == :b
		article = Article.new nil, { :a => 0.1, :b => 0.1 }
		article.main_class.should == :cant_decide
	end

end
