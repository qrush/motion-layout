# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'motion-layout/version'

Gem::Specification.new do |gem|
  gem.name          = "motion-layout"
  gem.version       = Motion::Layout::VERSION
  gem.authors       = ["Nick Quaranto"]
  gem.email         = ["nick@quaran.to"]
  gem.summary = gem.description = %q{A nice way to use iOS6+ autolayout in your RubyMotion app. Use ASCII-art inspired format strings to build your app's layout!}
  gem.homepage      = "https://github.com/qrush/motion-layout"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
