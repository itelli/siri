# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "Siriproxy-itelli"
  s.version     = "0.1.0" 
  s.authors     = ["ludwig heinz"]
  s.email       = [""]
  s.homepage    = ""
  s.summary     = %q{itelligence Siri Proxy}
  s.description = %q{SAP Siri Proxy plugin }

  s.rubyforge_project = "Siriproxy-itelli"

  s.files         = `git ls-files 2> /dev/null`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/* 2> /dev/null`.split("\n")
  s.executables   = `git ls-files -- bin/* 2> /dev/null`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "httparty"
end
