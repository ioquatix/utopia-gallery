
require 'utopia/content'

pages_root = File.expand_path('site/pages', __dir__)
gallery_root = File.expand_path('site/public/_gallery', __dir__)

use Utopia::Content,
	root: pages_root,
	namespaces: {
		'gallery' => Utopia::Gallery::Tags.new(media_root: pages_root, cache_root: gallery_root, cache_path: '/_gallery')
	}

run lambda{|env| [200, {}, []]}
