module MeteorMotion
	module Collections
		class MotionModel < MeteorMotion::Collection

			def initialize klass, aka=""
				# if !(klass < ::MeteorMotion::Adapters::MotionModel)
				# 	raise 'Adapter not compatible with collection'
				# end

				@klass = klass
				name = aka == "" ? klass.to_s.downcase : aka

				super name
			end

			def add id, fields
				obj = find(id)
				puts "ADDING: #{obj}"
				if obj
					obj.save({local: true})
				else
					obj = @klass.new({id: id}.merge(fields))
					obj.save({local: true})
				end

				super
			end

			def update id, fields, cleared
				obj = find(id)
				obj.attributes = fields
				obj.save({local: true})

				super
			end

			def remove id
				obj = find(id)
				if obj
					obj.destroy({local: true})
				end

				super
			end

			def find id
				obj = @klass.where(:id).eq(id).first
			end

		end
	end
end