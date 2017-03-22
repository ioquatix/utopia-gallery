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
		
		expect(last_response.body).to be == '<div class="gallery"><img src="/sample_images/IMG_3340.jpg"/><img src="/sample_images/IMG_3341.jpg"/><img src="/sample_images/IMG_3344.jpg"/><img src="/sample_images/IMG_3351.jpg"/></div>'
	end
end
