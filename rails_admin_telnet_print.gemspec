$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_admin_telnet_print/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_admin_telnet_print"
  s.version     = RailsAdminTelnetPrint::VERSION
  s.authors     = ["Gabriele Tassoni"]
  s.email       = ["gabrieletassoni@taris.it"]
  s.homepage    = "https://www.taris.it"
  s.summary     = "Printing to a set of predefined IP printers."
  s.description = "The set of printers must be present in the database."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "thecore", "~> 1.0"
end
