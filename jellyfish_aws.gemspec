$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'jellyfish_aws/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'jellyfish-aws'
  s.version     = JellyfishAws::VERSION
  s.authors     = ['Michael Stack']
  s.email       = ['michael.stack@gmail.com']
  s.homepage    = 'http://github.com/projectjellyfish/jellyfish-aws'
  s.summary     = 'Adds AWS products to Jellyfish'
  s.description = 'Adds AWS S3, EC2, RDS products to Jellyfish'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib,public}/**/*', 'LICENSE', 'Rakefile', 'README.rdoc']

  s.test_files = Dir['spec/**/*']
  s.add_dependency 'rails', '~> 4.2'
  s.add_dependency 'fog-aws', '~> 0.7'
  s.add_dependency 'bcrypt', '~> 3.1'

  s.add_development_dependency 'rspec-rails', '~> 3.3'
  s.add_development_dependency 'factory_girl_rails', '~> 4.5'
  s.add_development_dependency 'database_cleaner', '~> 1.4'
  s.add_development_dependency 'rubocop', '~> 0.34'
end
