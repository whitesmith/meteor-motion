module MeteorMotion
	module Collections
		class MotionModel < MeteorMotion::Collection

			def initialize klass, options = {}
				@klass = klass
				options[name] = klass.to_s.downcase unless options[name]

				super options[name]
			end

			def add id, fields

				super
			end

			def update id, fields, cleared

				super
			end

			def remove id

				super
			end

		end
	end
end