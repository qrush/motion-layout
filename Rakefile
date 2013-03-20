#!/usr/bin/env rake
require "bundler/gem_tasks"

desc "Test by generating an app"
task :default do
  dir = "MotionLayoutTest"
  `rm -rf #{dir}`
  `motion create #{dir}`
  `rm #{dir}/app_delegate.rb`
  `cp -r example/* #{dir}/`

  Dir.chdir(dir) do
    sh "bundle --local && rake"
  end
end
