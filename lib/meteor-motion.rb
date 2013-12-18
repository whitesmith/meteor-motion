require "meteor-motion/version"
BW.require 'motion/**/*.rb'

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

Motion::Project::App.setup do |app|
  app.vendor_project(File.expand_path(File.join(File.dirname(__FILE__), '../vendor/SocketRocket')), :static, cflags: "-fobjc-arc")
  app.libs += ['/usr/lib/libicucore.dylib']
 	app.frameworks += ['CFNetwork', 'Security', 'Foundation']
end