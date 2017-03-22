
require 'utopia/content'

PAGES_ROOT = File.expand_path('site/pages', __dir__)
GALLERY_ROOT = File.expand_path('site/public/_gallery', __dir__)

use Utopia::Content,
	root: PAGES_ROOT,
	namespaces: {
		'gallery' => Utopia::Gallery::Tags.new(media_root: PAGES_ROOT, cache_root: GALLERY_ROOT)
	}

run lambda{|env| [200, {}, []]}
