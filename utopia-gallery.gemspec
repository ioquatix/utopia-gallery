# coding: utf-8
require_relative 'lib/utopia/gallery/version'

Gem::Specification.new do |spec|
	spec.name          = "utopia-gallery"
	spec.version       = Utopia::Gallery::VERSION
	spec.authors       = ["Samuel Williams"]
	spec.email         = ["samuel.williams@oriontransfer.co.nz"]

	spec.summary       = %q{A gallery tag for use with the Utopia web framework.}
	spec.homepage      = "https://github.com/ioquatix/utopia-gallery"
	spec.license       = "MIT"

	spec.files         = `git ls-files`.split($/)
	spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths = ["lib"]
	
	spec.add_dependency "utopia", "~> 2.0"
	spec.add_dependency "trenni", "~> 3.1"
	spec.add_dependency "vips-thumbnail", "~> 1.1"
	
	spec.add_development_dependency "bundler", "~> 1.4"
	spec.add_development_dependency "rake", "~> 10.5"
	spec.add_development_dependency "rspec", "~> 3.5"
end
