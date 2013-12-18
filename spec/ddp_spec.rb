describe MeteorMotion::DDP do
	describe 'connect' do
		it 'connects with a valid hostname' do
			ddp = MeteorMotion::DDP.new
			ddp.connect

			wait 1.0 do
				ddp.websocket_ready.should.equal true
				ddp.session.should.not.equal nil
			end
		end
	end

	describe 'subscriptions' do

		def error message
			@error_msg = message
			resume
		end

		before do
			@ddp = MeteorMotion::DDP.new
			@ddp.connect
			@ddp.error_delegate = self
		end

		it 'successfully subscribes to an existing publication' do
			@ddp.sub('books')

			wait 1.0 do
				@ddp.collections['books']['status'].should.equal :ready
				@ddp.collections['books']['items'].size.should.equal 3
			end
		end


		it 'throws an exception if no matching publication is found' do
			@ddp.sub('posts')

			wait do
				@error_msg.should.equal "No publication found"
			end
		end

		it 'successfully unsubscribes to an existing publication' do
			@ddp.unsub('books')

			wait 1.0 do
				@ddp.collections['books']['items'].size.should.equal 0
			end
	end


	describe 'method calls' do
		def success result='success'
			@success = result
			resume
		end

		def error message
			@success = 'failure'
			resume
		end

		before do
			@ddp = MeteorMotion::DDP.new
			@ddp.connect
			@ddp.error_delegate = self
		end

		it 'successfully executes an existing remote call without params' do
			@ddp.call('echo', nil, self.success)

			wait do
				@success.should.equal 'success'
			end
		end

		it 'successfully executes an existing remote call with params' do
			@ddp.call('echo', 'ping', self.success)

			wait do
				@success.should.equal 'ping'
			end
		end

		it 'fails when calling a method that does not exist' do
			@ddp.call('someMethod', nil, self.success)

			wait do
				@success.should.be.equal 'failure'
			end
		end

	end
end