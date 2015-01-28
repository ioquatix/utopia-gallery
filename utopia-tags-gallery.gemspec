# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'utopia/tags/gallery/version'

Gem::Specification.new do |spec|
	spec.name          = "utopia-tags-gallery"
	spec.version       = Utopia::Tags::Gallery::VERSION
	spec.authors       = ["Samuel Williams"]
	spec.email         = ["samuel.williams@oriontransfer.co.nz"]
	spec.description   = <<-EOF
		Utopia is a website generation framework which provides a robust set of tools
		to build highly complex dynamic websites. It uses the filesystem heavily for
		content and provides frameworks for interacting with files and directories as
		structure representing the website.

		This package includes a useful <gallery> tag which can be used for displaying
		thumbnails of images, documents and movies from a directory.
	EOF
	spec.summary       = %q{A gallery tag for use with the Utopia web framework.}
	spec.homepage      = ""
	spec.license       = "MIT"

	spec.files         = `git ls-files`.split($/)
	spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths = ["lib"]

	spec.add_development_dependency "bundler", "~> 1.3"
	spec.add_development_dependency "rake"
	
	spec.add_dependency "utopia", "~> 1.0"
	spec.add_dependency "rmagick"
end
