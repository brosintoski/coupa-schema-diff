# -*- encoding: utf-8 -*-
require File.expand_path('../lib/coupa_schema_diff/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Bradley Rosintoski"]
  gem.email         = ["brosintoski@gmail.com"]
  gem.description   = %q{Compares schemas between two Coupa instances}
  gem.summary       = %q{Greate for upgrades}
  gem.homepage      = "https://github.com/brosintoski/coupa-schema-diff"

  # gem.files         = `git ls-files`.split($\)
  gem.files           = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
  gem.executables = ["coupa_schema_diff"]
  gem.add_runtime_dependency 'diffy' 
  gem.add_runtime_dependency 'trollop'

  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "coupa_schema_diff"
  gem.require_paths = ["lib"]
  gem.version       = CoupaSchemaDiff::VERSION
  gem.rubygems_version = %q{1.3.1}
end

