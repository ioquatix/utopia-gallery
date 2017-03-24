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

require 'vips/thumbnail'
require 'fileutils'

module Utopia
	module Gallery
		class Process
			def initialize(name)
				@name = name.to_sym
			end
			
			attr :name
			
			def relative_path(media)
				source_path = media.path
				
				File.join(File.dirname(source_path), @name.to_s, File.basename(source_path))
			end
			
			def fresh?(input_path, output_path)
				return File.exist?(output_path) && File.mtime(input_path) <= File.mtime(output_path)
			end
		end
		
		class ResizeImage < Process
			def initialize(name, size = [800, 800], method = :resize_to_fit, **options)
				super(name)
				
				@size = size
				@method = method
				@options = options
			end
			
			def call(cache, locals)
				output_path = cache.output_path_for(self)
				media = cache.media
				media_path = File.join(cache.media_root, media.path)
				
				return if fresh?(media_path, output_path)
				
				resizer = locals[:resizer] ||= Vips::Thumbnail::Resizer.new(media_path)
				
				FileUtils.mkdir_p(File.dirname(output_path))
				
				if output_image = resizer.send(@method, @size)
					output_image.write_to_file output_path, **@options
				else
					FileUtils.ln(media_path, output_path)
				end
			end
		end
	end
end
