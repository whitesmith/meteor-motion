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

		def handler action, result
			@called << action
		end

		before do
			@called = []
		end

		it 'calls the specified callback when called' do
			@client.call('ping', self.method(:handler) )

			wait 1.0 do
				@called.include?(:result).should.be.equal true
			end
		end

		it 'calls the provided handler with an error when a call fails' do
			@client.call('some_method', self.method(:handler) )

			wait 1.0 do
				@called.include?(:error).should.be.equal true
			end
		end

		it 'removes a callback after both replies have been received' do
			@client.call('ping', self.method(:handler) )

			@client.method_callbacks.size.should.be.equal 1

			wait 1.0 do
				@client.method_callbacks.size.should.be.equal 0
			end
		end
	end

	describe 'Authentication with username' do

		def login_handler action, result
			@action = action
			@result = result
		end

		it 'logins successfully with a correct u/p combo' do
			@client.login_with_username('user', 'pass', self.method(:login_handler))

			wait 3.0 do
				@action.should == :success
			end
		end

		it 'fails to login with an invalid username' do
			@client.login_with_username('no_such_user', 'pass', self.method(:login_handler))

			wait 2.0 do
				@action.should == :error
				@result[:reason].should == 'User not found'
			end
		end

		it 'fails to login with an incorrect password' do
			@client.login_with_username('user', 'wrong_pass', self.method(:login_handler))

			wait 3.0 do
				@action.should == :error
				@result[:reason].should == 'Incorrect password'
			end
		end

	end

end