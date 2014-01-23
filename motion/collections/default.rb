module MeteorMotion
	module Collections
		class Default < MeteorMotion::Collection

			def initialize name
				super
				@objects = {}
			end

			def add id, fields
				@objects[id] = fields
				super
			end


			def update id, fields, cleared
				obj = @objects[id].mutableCopy

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

				super
			end


			def remove id
				@objects.delete(id)
				super
			end

			def all
				@objects.map { |k,v| v.merge({:_id => k }) }
			end

			def find id
				return @objects[id]
			end

			def size
				return @objects.size
			end

		end
	end
end