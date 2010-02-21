require 'laplace'
describe 'laplace additions to array' do

	def r a,b
		Rational(a,b)
	end

	it 'should provide fraction helpers' do
		[r(1,2), r(3,4)].numerators.should == [1,3]
		[r(1,2), r(3,4)].denominators.should == [2,4]
	end

	it 'should provide waying of checking for at least one zero' do
		[r(1,2),r(3,4)].should_not have_at_least_one_zero
		[r(0,2),r(3,4)].should have_at_least_one_zero
		[r(1,2),r(0,4)].should have_at_least_one_zero
		[r(0,2),r(0,4)].should have_at_least_one_zero
	end

	it 'should calculate gcd' do
		[].gcd(5124,8346).should == 6
	end

	it 'should calculate lcm' do
		[3,4,3].lcm.should == 12
		[1281,2812].lcm.should == 3602172
	end

	it 'should calculate normalize proportions of a number of fractions' do
		fractions = [ r(4,11), r(7,13), r(21,25) ]
		fractions.normalized_proportions!
		(fractions[0]-0.2087).abs.should < 0.001
		(fractions[1]-0.3090).abs.should < 0.001
		(fractions[2]-0.4821).abs.should < 0.001
	end

	it 'should not reduce precision if not required' do
		r(4,11).reduce_precision.should == r(4,11)
	end

	it 'should not reduce precision if not required' do		
		r(238536779230955131, 20530008771411340224).reduce_precision.should == r(10000000000, 860664289909)
	end


	it 'should calc mean square err' do
		[1,2,3].mean_square_error([1,2,3]).should == 0
		[2,3,6].mean_square_error([1,2,3]).should == 3 + 2.0/3
	end

end

