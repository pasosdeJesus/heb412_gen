# frozen_string_literal: true

$:.push(File.expand_path("../lib", __FILE__))

# Maintain your gem's version:
require "heb412_gen/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "heb412_gen"
  s.version     = Heb412Gen::VERSION
  s.authors     = ["Vladimir Támara Patiño"]
  s.email       = ["vtamara@pasosdeJesus.org"]
  s.homepage    = "http://sivel.sf.net"
  s.summary     = "Motor para heb412"
  s.description = ""
  s.license     = "Dominio Público de acuerdo a Legislación Colombiana"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENCIA", "Rakefile", "README.md"]

  s.add_runtime_dependency("mr519_gen")
  s.add_runtime_dependency("msip")
  s.add_runtime_dependency("redcarpet")
  s.add_runtime_dependency("rspreadsheet")
end
