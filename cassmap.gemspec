# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cassmap/version'

Gem::Specification.new do |spec|
  spec.name          = "cassmap"
  spec.version       = Cassmap::VERSION
  spec.authors       = ["Ryan Svihla"]
  spec.email         = ["rs@foundev.pro"]
  spec.description   = %q{Cassandra ActiveModel implementation for Rails with migrations and full query table support.}
  spec.summary       = <<SUMMARY
  Good Cassandra data modeling embraces the distributed nature of the database, and makes heavy use of materialized views or as I like to refer to them "Query Tables". In this concept you denormalize your data and model your tables after the queries you need to preform in your application. Denormalization of course has downsides when it comes to data consistency and performance if you're making roundtrips for each table. Cassandra's api helps us solve the data consistency between query tables problem with the BATCH statment. Other Active Record implmentations do not allow you to batch these updates easily and most people resort to hand CQL and respositories to keep their data consisten. I aim to eliminate this boilerplate.
SUMMARY
  spec.homepage      = "https://github.com/rssvihla/cassmap"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.has_rdoc = true
  spec.extra_rdoc_files = 'README.md'

  spec.required_ruby_version = ">= 2.0"
  spec.add_runtime_dependency "cql-rb", "~> 1.2"
  spec.add_runtime_dependency "uuidtools"
  spec.add_runtime_dependency "activemodel", ">= 4.0.0"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"

  spec.requirements << 'Cassandra >= 2.0.0'

end
