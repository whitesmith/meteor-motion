module MeteorMotion
	class Client
		attr_accessor :collections, :subscriptions, :method_callbacks

		def initialize
			@collections = {}
			@subscriptions = {}
			@method_callbacks = {}

			@auth_client = nil
			@auth_key = nil

			@ddp = MeteorMotion::DDP.new self
			@error_handler = nil
		end


		def connect hostname='localhost', port=3000
			@ddp.connect hostname, port
		end


		def add_collection name
			if @collections[name]
				raise "A MeteorMotion::Collection named '#{name}' already exists."
			end

			@collections[name] = MeteorMotion::Collection.new name

			return @collections[name]
		end


		def remove_collection name
			@collections.delete(name)
		end


		def subscribe pub_name, params=[]
			sub_id = @ddp.sub(pub_name, params)
			@subscriptions[sub_id] = {name: pub_name, ready: false}

			return sub_id
		end

		def unsubscribe sub_id
			@ddp.unsub(sub_id)
			@subscriptions.delete(sub_id)
		end


		def call method_name, callback, params=[]
			method_id = @ddp.call(method_name, params)

			@method_callbacks[method_id] = { method: callback, result: false, updated: false}
		end


		# Methods for SRP authentication
		#
		def login_with_username username, password, callback
			@method_callbacks['login'] = callback
			if !@auth_client
				@auth_client = SRT::Client.new
			end

			@ddp.call( 'beginPasswordExchange')
		end


		def on_error method
			@error_handler = method
		end

		# Methods required for MeteorMotion::DDP delegation
		#
		def handle_method id, action, result
			callback = @method_callbacks[id]

			obj = { method: callback[:method], action: action, result: result}

			self.performSelectorInBackground('background_method_handler:', withObject: obj)

			if callback[action] == :error
				callback[action] = :result
			end

			callback[action] = true
			if callback[:result] && callback[:updated]
				@method_callbacks.delete(id)
			else
				@method_callbacks[id] = callback
			end
		end

		def error code, reason, details
			if @error_handler
				obj = { method: @error_handler, code: code, reason: reason, details: details}
				self.performSelectorInBackground('background_error_handler:', withObject: obj)
			else
				#TODO: silent error handling
			end
		end

		private
			def background_method_handler obj
				obj[:method].call( obj[:action], obj[:result])
			end

			def background_error_handler obj
				obj[:method].call( obj[:code], obj[:reason], obj[:details])
			end

	end
end