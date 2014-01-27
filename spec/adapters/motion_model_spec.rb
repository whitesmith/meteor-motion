class Books
	include MotionModel::Model
	include MotionModel::ArrayModelAdapter
	include MeteorMotion::Adapters::MotionModel
	

	# Make sure to define :id as String so MotionModel does not create a default int
	#
	columns :id => :string,
					:title => :string,
					:author => :string,
					:year => :string
end

describe MeteorMotion::Adapters::MotionModel do
	
	before do
		@client = MeteorMotion::Client.new
		@client.connect
		@client.add_collection(Books)
	end

	it 'should successfully populate a collection with data from the server' do
		wait 1.0 do
			@client.subscribe('books')
		end

		wait 2.0 do
			Books.all.count.should.be.equal 3

			book = Books.all.first
			book.title.should.be.equal "Foundation"
			book.author.should.be.equal "Isaac Asimov"
			book.year.should.be.equal "1951"
		end
	end

end