# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'meteor-motion/version'

Gem::Specification.new do |spec|
  spec.name          = "meteor-motion"
  spec.version       = MeteorMotion::VERSION
  spec.authors       = ["Miguel Tavares"]
  spec.email         = ["mtavares.azrael@gmail.com"]
  spec.description   = %q{Write a gem description}
  spec.summary       = %q{Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'bubble-wrap'
  spec.add_dependency 'rm-digest'
  spec.add_dependency 'motion_model'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "motion-redgreen"
end
