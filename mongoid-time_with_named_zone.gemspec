# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid/time_with_named_zone/version'

Gem::Specification.new do |spec|
  spec.name          = 'mongoid-time_with_named_zone'
  spec.version       = Mongoid::TimeWithNamedZone::VERSION
  spec.authors       = ['Carnival Mobile', 'Arthur Evstifeev', 'Artur Khantimirov']
  spec.email         = ['toby@carnivallabs.com']
  spec.summary       = %q{A Mongoid wrapper for Time objects that retains the timezone name}
  spec.description   = %q{This gem works transparently with ActiveSupport::TimeWithZone Times. See more: https://github.com/carnivalmobile/time-with-zone}
  spec.homepage      = 'https://github.com/carnivalmobile/time-with-zone'
  spec.license       = 'Apache 2'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'mongoid', '>= 3'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.1.0'
end
