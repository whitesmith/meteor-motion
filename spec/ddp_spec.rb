describe MeteorMotion::DDP do
	describe 'connect' do
		it 'connects with a valid hostname' do
			ddp = MeteorMotion::DDP.new self
			ddp.connect

			wait 1.0 do
				ddp.websocket_ready?.should.equal true
				ddp.session.should.not.equal nil
			end
		end
	end

	describe 'subscriptions' do

		def error code, reason, details
			@error_msg = reason
			resume
		end

		def collections
			return @collections
		end

		def subscriptions
			return @subscriptions
		end

		before do
			@ddp = MeteorMotion::DDP.new self
			@ddp.connect
			@collections = {'books' => MeteorMotion::Collection.new('books') }
			@subscriptions = {}

			wait 1.0 do
			end
		end

		it 'successfully subscribes to an existing publication' do
			@sub_id = @ddp.sub('books')
			@subscriptions[@sub_id] = {ready: false}

			wait 1.0 do
				@collections['books'].size.should.equal 3
				@subscriptions[@sub_id][:ready].should.equal true
			end
		end


		it 'receives a no-sub message if no matching publication is found' do
			@ddp.sub('posts')

			wait do
				@error_msg.should.equal "Subscription not found"
			end
		end

		it 'successfully unsubscribes to an existing publication' do
			@ddp.unsub( @sub_id )

			wait 1.0 do
				@collections['books'].size.should.equal 0
			end
		end

	end


	describe 'method calls' do

		def error code, reason, details
			@error_msg = reason
		end

		def handle_method id, type, results
			@success = results
		end

		before do
			@ddp = MeteorMotion::DDP.new self
			@ddp.connect
			wait 1.0 do
			end
		end

		it 'successfully executes an existing remote call without params' do
			@ddp.call('ping')

			wait 1.0 do
				@success.should.equal 'pong'
			end
		end

		it 'successfully executes an existing remote call with params' do
			@ddp.call('echo', {message: 'echo'} )

			wait 1.0 do
				@success.should.equal 'echo'
			end
		end

		it 'fails when calling a method that does not exist' do
			@ddp.call('someMethod')

			wait 1.0 do
				@error_msg.should.be.equal 'Method not found'
			end
		end

	end
end