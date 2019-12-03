# Copyright, 2019, by Samuel G. D. Williams. <http://www.codeotaku.com>
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

require 'utopia/gallery/cache'
require 'utopia/gallery/container'
require 'utopia/gallery/process'

RSpec.describe Utopia::Gallery::Cache do
	let(:pages_root) {File.join(__dir__, 'site/pages')}
	let(:cache_root) {File.join(__dir__, 'site/public/_gallery')}
	
	before(:each) do
		FileUtils.rm_rf cache_root
	end
	
	# Cache wants processes as a hash by name.
	let(:processes) do
		{
			small: Utopia::Gallery::ResizeImage.new(:small, [400, 400], :resize_to_fill),
			large: Utopia::Gallery::ResizeImage.new(:large, [800, 800], :resize_to_fit),
		}
	end
	
	let(:container) {Utopia::Gallery::Container.new(pages_root, 'sample_images')}
	
	subject{container.collect{|media| described_class.new(pages_root, cache_root, '/_gallery', media, processes)}}
	let(:output_paths) {subject.collect{|cache| cache.output_paths}.flatten}
	
	it "should generate thumbnails" do
		expect(subject.count).to be == 4
		expect(output_paths.count).to be == 8
		
		subject.each(&:update)
		
		output_paths.each do |output_path|
			expect(File).to be_exist(output_path)
		end
	end
	
	it "should preserve aspect ratio" do
		subject.each do |cache|
			cache.update
			
			input_image = Vips::Image.new_from_file(cache.input_path)
			input_image.autorot
			input_aspect_ratio = Rational(input_image.width, input_image.height)
			
			cache.outputs do |process, output_path|
				next unless process.method == :resize_to_fit
				
				output_image = Vips::Image.new_from_file(output_path)
				output_aspect_ratio = Rational(output_image.width, output_image.height)
				
				expect(output_aspect_ratio).to be_within(0.01).of(input_aspect_ratio)
			end
		end
	end
	
	it "it should be reentrant" do
		subject.each(&:update)
		
		expect{subject.each(&:update)}.to_not raise_error
	end
	
	it "can regeneate out of date media" do
		subject.each(&:update)
		
		sleep(1)
		
		subject.each do |cache|
			# Input path becomes newer than output path:
			# Exception: If output_path is a hard link to input_path.
			FileUtils.touch(cache.input_path)
			
			# It should no longer be fresh:
			cache.output_paths.each do |output_path|
				expect(Utopia::Gallery::Process).to_not be_fresh(cache.input_path, output_path)
			end
		end
		
		# Regenerate outputs:
		expect{subject.each(&:update)}.to_not raise_error
		
		# Everything should be fresh:
		subject.each do |cache|
			cache.output_paths.each do |output_path|
				expect(Utopia::Gallery::Process).to be_fresh(cache.input_path, output_path)
			end
		end
	end
end