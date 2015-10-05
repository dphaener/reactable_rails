$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "reactable_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "reactable_rails"
  s.version     = ReactableRails::VERSION
  s.authors     = ["dphaener"]
  s.email       = ["dphaener@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ReactableRails."
  s.description = "TODO: Description of ReactableRails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.4"

  s.add_development_dependency "sqlite3"
end
