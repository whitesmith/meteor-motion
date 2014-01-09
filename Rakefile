#!/usr/bin/env rake
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bundler/gem_tasks'
require 'bubble-wrap/test'
require 'bubble-wrap/core'
require 'rm-digest'
Bundler.setup
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'MeteorMotion Example'
  app.delegate_class = "AppDelegate"
end