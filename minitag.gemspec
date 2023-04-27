# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'minitag/version'

Gem::Specification.new do |spec|
  spec.name          = 'minitag'
  spec.version       = Minitag::VERSION
  spec.authors       = ['Bernardo de Araujo']
  spec.email         = ['bernardo.amc@gmail.com']

  spec.summary       = 'Provides the ability to tag your minitest tests.'
  spec.homepage      = 'https://github.com/bernardoamc/minitag'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 2.2.10'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rubocop', '~> 1.18'

  spec.add_dependency 'minitest', '~> 5.0'

  spec.required_ruby_version = '>= 2.5.0'
end
