module MeteorMotion
	class Collection
		attr_accessor :name, :observers

		def initialize name
			@name = name
			@objects = {}
			@observers = []
		end

		def add id, fields
			@objects[id] = fields
			notify_observers :added, id
		end


		def update id, fields, cleared
			obj = @objects[id]

			if fields
				fields.each do |k, v|
					obj[k] = v
				end
			end

			if cleared
				cleared.each do |key|
					obj.delete(key)
				end
			end

			@objects[id] = obj
			notify_observers :changed, id
		end


		def remove id
			@objects.delete(id)
			notify_observers :removed, id
		end

		def find id
			return @objects[id]
		end

		def size
			return @objects.size
		end


		def add_observer method
			@observers << method
		end

		def remove_observer method
			@observers.delete( method )
		end

		private
			def notify_observers action, id
				obj = {action: action, id: id}
				self.performSelectorInBackground('background_notify:', withObject: obj)
			end

			# These callbacks should be done as background tasks to prevent the connection thread from holding in intensive tasks
			#
			def background_notify object
				observers.each do |method_name|
					#puts "Calling method with action #{object[:action]}"
					method_name.call( object[:action], object[:id] )
				end
			end
	end
end