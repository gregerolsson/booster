# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'booster/version'

Gem::Specification.new do |s|
  s.name        = 'booster'
  s.version     = Booster::VERSION.dup
  s.authors     = ['Greger Olsson']
  s.email       = ['support@redstone.eu']
  s.homepage    = 'http://github.com/gregerolsson/booster'
  s.summary     = 'Wrapper library for Backbone.js'
  s.description = 'Integrates with Rails 3.x Asset Pipeline with some Backbone.js support'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'execjs'
  s.add_runtime_dependency 'tilt'
  s.add_development_dependency 'jasmine'
  s.add_development_dependency 'activesupport', '~> 3.1.0'
  s.add_development_dependency 'therubyracer'
  s.add_development_dependency 'rake'
end