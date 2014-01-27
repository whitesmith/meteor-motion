class DummyModel
	include MotionModel::Model
	include MotionModel::ArrayModelAdapter
	include MeteorMotion::Adapters::MotionModel
	

	# Make sure to define :id as String so MotionModel does not create a default int
	#
	columns :id => :string,
					:a => :int,
					:b => :int
end

describe MeteorMotion::Collections::MotionModel do
	describe 'Creation' do
		it 'creates a collection with a compatible class' do
			coll = MeteorMotion::Collections::MotionModel.new(DummyModel)
			coll.should.not.be.equal nil
			coll.name.should.be.equal 'dummymodel'
		end

		it 'sets a different name when it is provided' do
			coll = MeteorMotion::Collections::MotionModel.new(DummyModel, 'dums')
			coll.should.not.be.equal nil
			coll.name.should.be.equal 'dums'
		end
	end


	describe 'CRUD tasks' do

		before do
			@client = MeteorMotion::Client.new
			@client.connect
			@coll = MeteorMotion::Collections::MotionModel.new(DummyModel)
		end

		it 'adds an object to the collection and finds it' do
			@coll.add('abc', {a: 1, b:2})
			@coll.find('abc').should.not.be.equal nil
		end

		it 'adds the correct fields to the object' do
			@coll.add('abc', {a: 1, b:2})

			@coll.find('abc').a.should.be.equal 1
			@coll.find('abc').b.should.be.equal 2
		end

		it 'updates an objects fields' do
			@coll.add('abc', {a: 1, b:2})
			@coll.find('abc').a.should.be.equal 1

			@coll.update('abc', {a: 2}, nil)
			@coll.find('abc').a.should.be.equal 2
		end

		it 'removes an object from the collection' do
			@coll.add('abc', {a: 1, b:2})

			wait 1.0 do
				@coll.remove('abc')
				@coll.find('abc').should.be.equal nil
			end
		end

	end
	
end