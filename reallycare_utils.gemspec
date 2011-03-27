# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "reallycare_utils/version"

Gem::Specification.new do |s|
  s.name        = "reallycare_utils"
  s.version     = ReallycareUtils::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mark Chapman", "Andy Jeffries"]
  s.email       = ["mark.chapman@gmail.com", "andy@andyjeffries.co.uk"]
  s.homepage    = ""
  s.summary     = %q{Shared utilities for ReallyCare sites}
  s.description = %q{A collection of shared utilities for ReallyCare sites}

  s.rubyforge_project = "reallycare_utils"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
