require 'core_extensions'

describe 'array extensions' do

	it 'should correctly convert empty array to empty frequency hash' do
		[].frequency_hash.should == {}
	end

	it 'should correctly  convert array with two elements appearing twice' do
		[:a,:b].frequency_hash.keys.size.should == 2
		[:a,:b].frequency_hash[:a].should == 1
		[:a,:b].frequency_hash[:b].should == 1
	end

	it 'should correctly convert array with three elements that appear multiple times' do
		[:a,:b,:b,:a,:c].frequency_hash.keys.size.should == 3
		[:a,:b,:b,:a,:c].frequency_hash[:a].should == 2
		[:a,:b,:b,:a,:c].frequency_hash[:b].should == 2
		[:a,:b,:b,:a,:c].frequency_hash[:c].should == 1
	end

end

describe 'fixnum extensions' do

	it '1! == 1' do
		1.factorial.should == 1
	end

	it '3! == 6' do
		3.factorial.should == 6
	end

	it '7! == 5040' do
		7.factorial.should == 5040
	end

end
