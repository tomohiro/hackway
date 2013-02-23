# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hackway/version'

Gem::Specification.new do |gem|
  gem.name          = 'hackway'
  gem.version       = Hackway::VERSION
  gem.authors       = ['Tomohiro TAIRA']
  gem.email         = ['tomohiro.t@gmail.com']
  gem.description   = 'Hacker News IRC Gateway'
  gem.summary       = 'Hacker News IRC Gateway'
  gem.homepage      = 'https://github.com/Tomohiro/hackway'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'slop'
  gem.add_runtime_dependency 'net-irc'
  gem.add_runtime_dependency 'nokogiri'

  gem.add_development_dependency 'rake'
end
