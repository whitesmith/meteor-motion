describe MeteorMotion::Collection do

	describe 'creating' do
		it 'creates a new collection with a name' do
			coll = MeteorMotion::Collection.new('temp')

			coll.name.should.be.equal 'temp'
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
			@coll.update('abc', {a: 2}, nil)

			wait 1.0 do
				@action.should.be.equal :changed
			end
		end

		it 'notifies a subscribed observer after removing an item' do
			@coll.add_observer( self.method(:collection_handler) )
			@coll.remove('abc')

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