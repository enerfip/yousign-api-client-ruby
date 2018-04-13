# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)

require 'yousign_api/version'


Gem::Specification.new do |spec|
  spec.name          = "yousign_api"
  spec.version       = YousignApi::VERSION
  spec.authors       = ["Raphael Faye"]
  spec.email         = ["fayeraphael@yahoo.fr"]

  spec.summary       = "Ruby client for Yousign API"

  spec.required_ruby_version = ">= 1.9"

  spec.files = Dir["{lib}/**/*"] + Dir["{config}/**/*"] + Dir["{spec}/**/*"] + Dir["{examples}/**/*"] + ["Rakefile", "README.md"]

  spec.require_paths = ['lib']

  spec.add_dependency "savon", "~>2.11", '>= 2.11.0'
  spec.add_dependency "nokogiri"
  spec.add_dependency "rake"
  spec.add_development_dependency "rspec"
end
