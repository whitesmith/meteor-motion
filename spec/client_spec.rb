describe MeteorMotion::Client do

	before do
		@client = MeteorMotion::Client.new
		@client.connect
		wait 1.5 do
		end
	end

	describe 'Collections' do
		it 'adds and removes collections' do
			@client.add_collection('books')
			@client.collections['books'].should.not.be.equal nil

			@client.remove_collection('books')
			@client.collections['books'].should.be.equal nil
		end
	end

	describe 'Subscriptions' do
		it 'adds and removes subscriptions' do
			id = @client.subscribe('books')
			@client.subscriptions[id].should.not.be.equal nil

			wait 1.0 do
				@client.unsubscribe(id)
				@client.subscriptions[id].should.be.equal nil
			end
		end
	end

	describe 'Method calls' do

		def error code, reason, details
			@error = :error
		end

		def handler action, result
			@called = :handler
		end

		before do
			@client.on_error(self, :error)
		end

		it 'calls the specified callback when called' do
			@client.call('ping', {object: self, method: :handler} )

			wait 1.0 do
				@called.should.be.equal :handler
			end
		end

		it 'calls the provided error handler when a call fails' do
			@client.call('some_method', {object: self, method: :handler} )

			wait 1.0 do
				@error.should.be.equal :error
			end
		end

		it 'removes a callback after both replies have been received' do
			@client.call('ping', {object: self, method: :handler} )

			@client.method_callbacks.size.should.be.equal 1

			wait 1.0 do
				@client.method_callbacks.size.should.be.equal 0
			end
		end
	end

end