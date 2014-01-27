module MeteorMotion
	module Adapters
		module MotionModel
			include ::MotionModel::ArrayModelAdapter

			def self.set_client client
				@@client = client
			end



			# Sends the data to the server and supers for the record to be saved. If saving on the server fails
			# it has to be dealt with by the user.
			def do_insert options = {}
				if !options[:local]
					attr_hash = build_attr_hash
					id = SecureRandom.hex
					@@client.call("/#{self.class.to_s.downcase}/insert", self.method(:handle_update), [{_id: id}.merge(attr_hash)])
				end

				super
			end

			def do_update options = {}
				if !options[:local]
					id = self.get_attr(:id)
					@@client.call("/#{self.class.to_s.downcase}/update", self.method(:handle_update), [{_id: id}, attr_hash])
				end

				super
			end

			def do_delete 
				send_remove

				super
			end

			def send_remove
				id = self.get_attr(:id)
				@@client.call("/#{self.class.to_s.downcase}/remove", self.method(:handle_remove), [{_id: id}])
			end
			
			def build_attr_hash
				attributes.reject{|k,v| k == :id}
			end

			# Stubs to handle inserts, updates and deletes. Can be overrriden by superclass
			#
			def handle_insert action, result; end
			def handle_update action, result; end
			def handle_remove action, result; end

			# Nasty, nasty hack to work around inheritance issues. TODO: refactor as adapter.
			def superclass
				return Object
			end

		end
	end
end