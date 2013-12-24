module MeteorMotion
	class DDP
		attr_accessor :session, :error_handler

		def initialize delegate
			@ws = nil
			@status = :closed
			@session = nil
			@call_id = 0

			@delegate = delegate
		end


		# Open up the websocket to the provided hostname and start listening for messages
		#
		def connect hostname="localhost", port=3000
			@ws = SRWebSocket.new
			@ws.initWithURL( NSURL.alloc.initWithString "http://#{hostname}:#{port}/websocket" )
			@ws.delegate = self
			@ws.open
		end


		# Subscribe to the publication specified by pub_name
		#
		def sub pub_name, params = []
			id = SecureRandom.hex
			msg = {msg: 'sub', id: id, name: pub_name, params: build_params(params) }
			send_message msg
			
			return id
		end


		# Unsubscribe to the publication with the specified id
		#
		def unsub id
			msg = {msg: 'unsub', id: id}
			send_message msg
		end


		# Call the specified method_name on the server, with optional params
		#
		def call method_name, params=[]
			id = @call_id.to_s
			@call_id = @call_id.next

			msg = {msg: 'method', method: method_name, params: build_params(params), id: id}
			send_message msg

			return id
		end


		def websocket_ready?
			@status == :socket_ready || @status == :connected
		end

		# Implementation of SRWebSocketDelegate to handle SRWebSocket callbacks
		#
		def webSocket(webSocket, didReceiveMessage: message)
			handle_message message
		end

		def webSocketDidOpen ws
			@status = :socket_ready
			msg = {msg: 'connect',version: 'pre1', support: ['pre1']}
			send_message msg 
		end

		def didFailWithError error
			puts "WebSocket send failed. Error code: #{error.code}"
		end

		def didCloseWithCode code, reason, was_clean
			@status = :closed
			puts "WebSocket closed"
		end
		#
		# End of SRWebsocketDelegate implementation



		private
			def send_message msg
				puts BW::JSON.generate(msg)
				@ws.send BW::JSON.generate(msg)
			end

			def handle_message msg
				puts msg
				json_string = msg.dataUsingEncoding(NSUTF8StringEncoding)
    		e = Pointer.new(:object)
    		data = NSJSONSerialization.JSONObjectWithData(json_string, options:0, error: e)

				case data[:msg]
				when 'connected'
					@status = :connected
					@session = data[:session]
				when 'failed'
					#TODO: Handle failed connections better
				when 'nosub'
					if data[:error]
						@delegate.error( data[:error][:error], data[:error][:reason], data[:error][:details] )
					end
				when 'added', 'changed', 'removed'
					collection = @delegate.collections[data[:collection]]

					if collection
						if data[:msg] == 'added'
							collection.add( data[:id], data[:fields])
						elsif data[:msg] == 'changed'
							collection.update( data[:id], data[:fields], data[:cleared] )
						elsif data[:msg] == 'removed'
							collection.remove( data[:id] )
						end
					else
						#TODO: Handle data that does not have a collection to reside in
					end
				when 'ready'
					data[:subs].each do |sub_id|
						@delegate.subscriptions[sub_id][:ready] = true
					end
				when 'result'
					if data[:error]
						@delegate.handle_method( data[:id], :error, data[:error] )
					else
						@delegate.handle_method( data[:id], :result, data[:result] )
					end
				when 'updated'
					data[:methods].each do |method_id|
						@delegate.handle_method( method_id, :updated, nil )
					end
				when 'error'
					@delegate.error( nil, data[:reason], data[:offendingMessage] ) 

				else
					puts "Received unknown message: #{msg}\n"
				end
				
			end

			def build_params params
				if params == [] || !params
					return []
				end

				#return params.each.map {|k,v| {k => v} }
				if params.kind_of?(Array)
					return params
				else
					return [params]
				end
			end

	end
end