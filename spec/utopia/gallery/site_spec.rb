# Copyright, 2012, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'rack/test'
require 'utopia/content'

describe Utopia::Gallery do
	include Rack::Test::Methods
	
	let(:app) {Rack::Builder.parse_file(File.expand_path('site_spec.ru', __dir__)).first}
	
	let(:cache_root) {File.join(__dir__, 'site/public/_gallery')}
	
	before(:each) do 
		FileUtils.rm_rf cache_root
	end
	
	it "should generate gallery of sample images" do
		get "/index"
		
		expect(last_response.body).to be == '<div class="gallery"><img src="/sample_images/IMG_3340.jpg" alt="IMG_3340"/><img src="/sample_images/IMG_3341.jpg" alt="IMG_3341"/><img src="/sample_images/IMG+3344.jpg" alt="IMG 3344"/><img src="/sample_images/IMG_3351.jpg" alt="IMG_3351"/></div>'
	end
	
	it "should generate a gallery using the specified tag" do
		get "/gallery"
		
		expect(last_response.body).to be == '<div class="gallery"><span class="photo">
	<a rel="photos" class="thumbnail" href="/_gallery/sample_images/large/IMG_3340.jpg" title="IMG_3340">
		<img src="/_gallery/sample_images/small/IMG_3340.jpg" alt="IMG_3340"/>
	</a>
	<div class="caption">IMG_3340</div>
</span>
<span class="photo">
	<a rel="photos" class="thumbnail" href="/_gallery/sample_images/large/IMG_3341.jpg" title="IMG_3341">
		<img src="/_gallery/sample_images/small/IMG_3341.jpg" alt="IMG_3341"/>
	</a>
	<div class="caption">IMG_3341</div>
</span>
<span class="photo">
	<a rel="photos" class="thumbnail" href="/_gallery/sample_images/large/IMG+3344.jpg" title="IMG 3344">
		<img src="/_gallery/sample_images/small/IMG+3344.jpg" alt="IMG 3344"/>
	</a>
	<div class="caption">IMG 3344</div>
</span>
<span class="photo">
	<a rel="photos" class="thumbnail" href="/_gallery/sample_images/large/IMG_3351.jpg" title="IMG_3351">
		<img src="/_gallery/sample_images/small/IMG_3351.jpg" alt="IMG_3351"/>
	</a>
	<div class="caption">IMG_3351</div>
</span>
</div>'
	end
end
