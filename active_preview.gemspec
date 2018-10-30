$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_preview/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active_preview"
  s.version     = ActivePreview::VERSION
  s.authors     = ["Syd Young"]
  s.email       = ["sky@eff.org"]
  s.summary       = %q{Create previews of ActiveRecord objects that don't                                                                                                               
                       modify the database}                                   
  s.homepage      = "https://github.com/efforg/active_preview"  
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.6"

  s.add_development_dependency "rake", "~> 10.0"                              
  s.add_development_dependency "rspec-rails", "~> 3.0"                              
  s.add_development_dependency "database_cleaner", "~> 1.7"                   
  s.add_development_dependency "sqlite3", "~> 1.3"                            
  s.add_development_dependency "byebug"
end
