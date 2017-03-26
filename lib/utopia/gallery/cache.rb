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

module Utopia
	module Gallery
		class Cache
			# @param root [String] The root path for media files.
			def initialize(media_root, cache_root, cache_path, media, processes)
				# TODO: It's a lot of things to keep track of... perhaps a configuration class?
				@media_root = media_root
				@cache_root = cache_root
				@cache_path = cache_path
				@media = media
				
				@processes = processes
			end
			
			attr :media_root
			attr :cache_root
			attr :processes
			attr :media
			
			def to_s
				@media.path
			end
			
			def input_path
				File.join(@media_root, @media.path)
			end
			
			def output_paths
				@processes.values.collect{|process| output_path_for(process)}
			end
			
			def outputs
				return to_enum(:outputs) unless block_given?
				
				@processes.values do |process|
					yield process, output_path_for(process)
				end
			end
			
			def output_path_for(process)
				File.join(@cache_root, process.relative_path(@media))
			end
			
			def source_path_for(process)
				File.join(@cache_path, process.relative_path(@media))
			end
			
			# Process the media, update files in the cache.
			def update
				locals = {}
				
				@processes.values.each do |process|
					process.call(self, locals)
				end
				
				return self
			end
			
			# This allows dynamic path lookup based on process name, e.g. `cache.small`.
			def method_missing(name, *args)
				if process = @processes[name]
					return source_path_for(process)
				else
					super
				end
			end
			
			def respond_to?(name)
				@processes.include?(name) || super
			end
		end
	end
end
