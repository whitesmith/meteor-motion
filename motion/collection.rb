module MeteorMotion
	class Collection
		attr_accessor :name, :observers

		def initialize name
			@name = name
			@observers = []
		end

		# Method hooks - be sure to call super after reimplementing these
		# Right now these are here more for testing purposes, should be reimplemented as a hook with some testing compromise
		#
		def add id, fields
			notify_observers :added, id
		end

		def update id, fields, cleared
			notify_observers :changed, id
		end

		def remove id
			notify_observers :removed, id
		end

		# Observer methods
		#
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