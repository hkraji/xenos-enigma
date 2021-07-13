$LOAD_PATH.unshift File.expand_path('lib', File.dirname(__FILE__))
require_relative 'lib/xenos_enigma/version'

Gem::Specification.new do |gem|
  gem.name = 'xenos-enigma'
  gem.version = ::XenosEnigma::VERSION
  gem.authors = ['Haris Krajina']
  gem.email = ['haris.krajina@gmail.com']
  gem.license = 'MIT'
  gem.date = Time.now.strftime('%Y-%m-%d')
  gem.summary = 'Space invaders radar put in the world of 40k'
  gem.homepage = 'http://github.com/hkraji/xenos-enigma'
  gem.executables = %w(xenos-enigma)

  gem.extra_rdoc_files = ['CHANGELOG', 'LICENSE', 'README.md']
  gem.files = Dir['lib/**/*', 'CHANGELOG', 'LICENSE', 'README.md']
  gem.test_files = Dir['spec/**/*.rb']
  gem.require_path = 'lib'

  gem.add_development_dependency 'rspec', '~> 3.1.0'

  gem.required_ruby_version = ['>= 2.4']
end
