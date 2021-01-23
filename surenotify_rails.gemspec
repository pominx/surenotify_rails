$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "surenotify_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "surenotify_rails"
  s.version     = SurenotifyRails::VERSION
  s.authors     = ["Leo Chen"]
  s.email       = ["pominx@gmail.com"]
  s.homepage    = "https://github.com/pominx/surenotify_rails/"
  s.summary     = "Rails Action Mailer adapter for Surenotify"
  s.description = "An adapter for using Surenotify with Rails and Action Mailer"
  s.license = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "actionmailer", ">= 4.2.11"
  s.add_dependency "json", ">= 2.1.0"
  s.add_dependency "rest-client", ">= 2.0.2"

  s.add_development_dependency "rspec", '~> 2.14.1'
  s.add_development_dependency "rails", ">= 4.2.11"
end
