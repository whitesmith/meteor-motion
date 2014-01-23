describe MeteorMotion::Collections::Default do
	
	describe 'CRUD tasks' do

		before do
			@coll = MeteorMotion::Collections::Default.new('temp')
		end

		it 'adds an object to the collection and finds it' do
			@coll.add('abc', {a: 1, b:2})
			@coll.find('abc').should.not.be.equal nil
		end

		it 'adds the correct fields to the object' do
			@coll.add('abc', {a: 1, b:2})

			@coll.find('abc')[:a].should.be.equal 1
			@coll.find('abc')[:b].should.be.equal 2
		end

		it 'updates an objects fields' do
			@coll.add('abc', {a: 1, b:2})
			@coll.find('abc')[:a].should.be.equal 1

			@coll.update('abc', {a: 2}, nil)
			@coll.find('abc')[:a].should.be.equal 2
		end

		it 'clears an objects fields' do
			@coll.add('abc', {a: 1, b:2})
			@coll.find('abc')[:a].should.be.equal 1

			@coll.update('abc', nil, [:a])
			@coll.find('abc')[:a].should.be.equal nil
		end

		it 'removes an object from the collection' do
			@coll.add('abc', {a: 1, b:2})

			@coll.remove('abc')
			@coll.find('abc').should.be.equal nil
		end

	end

end
