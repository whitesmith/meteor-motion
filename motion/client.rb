module MeteorMotion
	class Client
		attr_accessor :collections, :subscriptions, :method_callbacks

		def initialize
			@collections = {}
			@subscriptions = {}
			@method_callbacks = {}

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

			@method_callbacks[method_id] = {object: callback[:object], method: callback[:method], result: false, updated: false}
		end


		def on_error object, method
			@error_handler = {object: object, method: method}
		end

		# Methods required for MeteorMotion::DDP delegation
		#
		def handle_method id, action, result
			callback = @method_callbacks[id]

			obj = {object: callback[:object], method: callback[:method], action: action, result: result}

			self.performSelectorInBackground('background_method_handler:', withObject: obj)

			callback[action] = true
			if callback[:result] && callback[:updated]
				@method_callbacks.delete(id)
			else
				@method_callbacks[id] = callback
			end
		end

		def error code, reason, details
			if @error_handler
				obj = {object: @error_handler[:object], method: @error_handler[:method], code: code, reason: reason, details: details}
				self.performSelectorInBackground('background_error_handler:', withObject: obj)
			else
				#TODO: silent error handling
			end
		end

		private
			def background_method_handler obj
				obj[:object].method(obj[:method]).call( obj[:action], obj[:result])
			end

			def background_error_handler obj
				obj[:object].method(obj[:method]).call( obj[:code], obj[:reason], obj[:details])
			end

	end
end