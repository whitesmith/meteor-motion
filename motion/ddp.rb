module MeteorMotion
	class DDP
		attr_accessor :session, :error_handler

		def initialize
			@ws = nil
			@collections = {}
			@callbacks = {}
			@status = :closed
			@session = nil
			@next_id = 0
			@error_handler = nil
		end

		# Open up the websocket to the provided hostname and start listening for messages
		def connect hostname="localhost", port=3000
			@ws = SRWebSocket.new
			@ws.initWithURL( NSURL.alloc.initWithString "http://#{hostname}:#{port}/websocket" )
			@ws.delegate = self
			@ws.open
		end

		# Subscribe to the publication specified by pub_name
		def sub pub_name
		end

		# Unsubscribe to the publication specified by pub_name
		def unsub pub_name
		end

		# Call the specified method_name on the server, with optional params
		def call method_name, params=nil, callback = nil
		end

		def websocket_ready
			@status == :ready
		end

		#
		# Implementation of SRWebSocketDelegate to handle SRWebSocket callbacks
		#
		def webSocket(webSocket, didReceiveMessage: message)
			handle_message message
		end

		def webSocketDidOpen ws
			@status = :ready
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


		private
			def send_message msg
				@ws.send BW::JSON.generate(msg)
			end

			def handle_message msg
				puts msg.class
				puts msg
				json_string = msg.dataUsingEncoding(NSUTF8StringEncoding)
    		e = Pointer.new(:object)
    		data = NSJSONSerialization.JSONObjectWithData(json_string, options:0, error: e)

				case data[:msg]
				when 'connected'
					@session = data[:session]
				when 'failed'

				when 'nosub'

				when 'added'

				when 'changed'

				when 'removed'

				when 'ready'

				when 'result'

				when 'updated'

				when 'error'

				else
					puts "Received unknown message: #{msg}\n"
				end
				
			end

	end
end