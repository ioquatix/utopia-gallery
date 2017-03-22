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

require_relative 'media'

module Utopia
	module Gallery
		class Container
			include Enumerable
			
			def initialize(root, path, filter: /(jpe?g|png)$/i)
				@root = root
				@path = path
				@filter = filter
			end
			
			def each
				return to_enum unless block_given?
				
				gallery_metadata = load_metadata
				
				entries.each do |name|
					path = File.join(@path, name)
					media_metadata = gallery_metadata.delete(name)
					
					yield Media.new(path, media_metadata || {})
				end
			end
			
			private
			
			def full_path
				File.join(@root, @path)
			end
			
			def entries
				Dir.entries(full_path).select{|name| name =~ @filter}
			end
			
			def load_metadata
				metadata_path = File.join(full_path, 'gallery.yaml')
				
				if File.exist? metadata_path
					return YAML::load(File.read(metadata_path))
				else
					return {}
				end
			end
		end
	end
end
