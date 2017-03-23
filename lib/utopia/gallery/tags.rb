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

require 'utopia/content/namespace'

require_relative 'container'
require_relative 'process'
require_relative 'cache'

module Utopia
	module Gallery
		class Tags
			DEFAULT_PROCESSES = [
				ResizeImage.new(:small, [400, 400], :resize_to_fill),
				ResizeImage.new(:medium, [800, 800], :resize_to_fill),
				ResizeImage.new(:large, [1600, 1600], :resize_to_fit),
			]
			
			# @param media_root [String] Directory where media is stored.
			# @param cache_root [String] Directory where media is cached.
			# @param cache_root [String] The prefix path for the cached assets, served as static content.
			def initialize(media_root: Utopia.default_root, cache_root: Utopia.default_root('public/_gallery'), cache_path: '/_gallery', processes: DEFAULT_PROCESSES)
				@media_root = media_root
				@cache_root = cache_root
				@cache_path = cache_path
				@processes = {}
				
				processes.each do |process|
					name = process.name
					
					raise ArgumentError.new("Duplicate process #{name}") if @processes.include?(name)
					
					@processes[name] = process
				end
			end
			
			def container(document, state)
				node = document.parent.node
				path = node.uri_path.dirname + state[:path]
				
				options = {}
				if filetypes = state[:filetypes]
					options[:filter] = Regexp.new("(#{filetypes})$", Regexp::IGNORECASE)
				elsif filter = state[:filter]
					options[:filter] = Regexp.new(filter, Regexp::IGNORECASE)
				end
				
				# Where should we get this from?
				container = Container.new(@media_root, path, **options)
				
				media_tag_name = state[:tag] || 'img'
				
				document.tag('div', class: 'gallery') do
					container.each do |media|
						cache = Cache.new(@media_root, @cache_root, @cache_path, media, @processes).update
						document.tag(media_tag_name, src: cache, alt: media)
					end
				end
			end
			
			def call(name, node)
				# TODO: Validate security implications/leaky abstraction.
				self.method(name)
			end
		end
	end
end
