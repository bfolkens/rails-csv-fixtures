$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails-csv-fixtures/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails-csv-fixtures"
  s.version     = RailsCsvFixtures::VERSION
  s.authors     = ["Brad Folkens"]
  s.email       = ["bfolkens@gmail.com"]
  s.homepage    = "http://github.com/bfolkens/rails-csv-fixtures"
  s.summary     = "Restores functionality of CSV based fixtures in Rails 3.2+"
  s.description = "This plugin restores the functionality of CSV based fixtures that was removed from Rails 3.2+"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", [">= 3.2", "< 5.0"]

  s.add_development_dependency "sqlite3"
end
