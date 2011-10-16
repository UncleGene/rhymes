# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rhymes/version"

Gem::Specification.new do |s|
  s.name        = "rhymes"
  s.version     = Rhymes::VERSION
  s.authors     = ["Eugene Kalenkovich"]
  s.email       = ["rubify@softover.com"]
  s.homepage    = ""
  s.summary     = %q{Lookup perfect and identical rhymes}
  s.description = %q{Lookup perfect and identical rhymes}}

  s.rubyforge_project = "rhymes"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
  s.add_development_dependency "rspec"
end
