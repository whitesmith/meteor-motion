describe MeteorMotion::Collection do

	describe 'creating' do
		it 'creates a new collection with a name' do
			coll = MeteorMotion::Collection.new('temp')

			coll.name.should.be.equal 'temp'
		end
	end

	describe 'CRUD tasks' do

		before do
			@coll = MeteorMotion::Collection.new('temp')
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

	describe 'observers' do

		def collection_handler action, id
			@action = action
		end

		before do
			@coll = MeteorMotion::Collection.new('temp')
		end

		it 'adds an observer to the collection' do
			@coll.add_observer( self.method(:collection_handler) )
			@coll.observers.size.should.be.equal 1
		end

		it 'notifies a subscribed observer after adding an item' do
			@coll.add_observer( self.method(:collection_handler) )
			@coll.add('abc', {a: 1, b:2})

			wait 1.0 do
				@action.should.be.equal :added
			end
		end

		it 'notifies a subscribed observer after updating an item' do
			@coll.add_observer( self.method(:collection_handler) )
			@coll.add('abc', {a: 1, b:2})

			wait 1.0 do
				@coll.update('abc', {a: 2}, nil)
			end

			wait 1.5 do
				@action.should.be.equal :changed
			end
		end

		it 'notifies a subscribed observer after removing an item' do
			@coll.add_observer( self.method(:collection_handler) )
			@coll.add('abc', {a: 1, b:2})

			wait 1.0 do
				@coll.remove('abc')
			end

			wait 1.5 do
				@action.should.be.equal :removed
			end
		end

		it 'removes observers from the collection' do
			@coll.add_observer( self.method(:collection_handler) )
			@coll.observers.size.should.be.equal 1

			@coll.remove_observer( self.method(:collection_handler) )
			@coll.observers.size.should.be.equal 0
		end

	end

end