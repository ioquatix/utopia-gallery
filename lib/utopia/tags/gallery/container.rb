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

require 'fileutils'

module Utopia
	module Tags
		module Gallery
			CACHE_DIR = "_cache"
			
			class Path
				def initialize(original_path)
					@original_path = original_path
					@cache_root = @original_path.dirname + CACHE_DIR
			
					@extensions = {}
				end

				attr :cache_root
				attr :extensions

				def original
					@original_path
				end

				def self.append_suffix(name, suffix, extension = nil)
					offset = name.rindex('.')
					
					name = name.dup
					
					if extension
						name[offset..-1] = '.' + suffix + '.' + extension
					else
						name.insert(offset, '.' + suffix)
					end
					
					return name
				end

				def processed(process = nil)
					if process
						name = @original_path.last
						return cache_root + Path.append_suffix(name, process.to_s, @extensions[process.to_sym])
					else
						return @original_path
					end
				end
		
				def to_html(process = nil)
					Tag.new("img", {"src" => path(process)}).to_html
				end
		
				def to_s
					@original_path.to_s
				end
		
				def method_missing(name, *args)
					return processed(name.to_s)
				end
			end
		
			class Container
				include Enumerable
				
				def initialize(node, path, processes = Processes::DEFAULT)
					@node = node
					@path = path
					
					@processes = processes
				end
				
				def metadata_path
					@node.local_path(@path + "gallery.yaml")
				end
				
				def metadata
					metadata_path = self.metadata_path
					
					if File.exist? metadata_path
						return YAML::load(File.read(metadata_path))
					else
						return {}
					end
				end
	
				def each(options = {})
					return to_enum(:each, options) unless block_given?
					
					options[:filter] ||= /(jpg|png)$/i

					paths = []
					local_path = @node.local_path(@path)

					Dir.entries(local_path).each do |filename|
						next unless filename.match(options[:filter])

						path = Path.new(@path + filename)

						process!(path, options[:process]) if options[:process]

						yield path
					end
				end
	
				def process!(image_path, processes)
					# Create the local cache directory if it doesn't exist already
					local_cache_path = @node.local_path(image_path.cache_root)
		
					unless File.exist? local_cache_path
						FileUtils.mkdir local_cache_path
					end
		
					# Calculate the new name for the processed image
					local_original_path = @node.local_path(image_path.original)
		
					if processes.kind_of? String
						processes = processes.split(",").collect{|p| p.split(":")}
					end
		
					processes.each do |process_name, extension|
						process_name = process_name.to_sym
			
						process = @processes[process_name]
						extension ||= process.default_extension(image_path)
			
						image_path.extensions[process_name] = extension if extension
			
						local_processed_path = @node.local_path(image_path.processed(process_name))
			
						unless File.exists? local_processed_path
							image = Magick::ImageList.new(local_original_path)
							image.scene = 0
				
							processed_image = process.call(image)
							processed_image.write(local_processed_path)
				
							# Run GC to free up any memory.
							image = processed_image = nil
							GC.start if defined? GC
						end
					end
				end
			end
		end
	end
end
