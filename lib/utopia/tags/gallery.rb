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

require_relative 'gallery/thumbnail'
require_relative 'gallery/container'

module Utopia
	module Tags
		module Gallery
			class Metadata
				def initialize(metadata)
					@metadata = metadata
				end

				attr :metadata

				def [] (key)
					@metadata[key.to_s]
				end

				def to_s
					@metadata['caption'] || ''
				end

				def to_html
					to_s.to_html
				end
			end
	
			def self.call(transaction, state)
				container = Container.new(transaction.end_tags[-2].node, Utopia::Path.create(state[:path] || "./"))
				metadata = container.metadata
				metadata.default = {}

				tag_name = state[:tag] || "img"
				container_class = state[:class] || "gallery"

				options = {}
				options[:process] = state[:process]
				
				if filetypes = state[:filetypes]
					options[:filter] = Regexp.new("(#{filetypes})$", "i")
				end
				
				if filter = state[:filter]
					filter = Regexp.new(filter, Regexp::IGNORECASE)
				end

				transaction.tag("div", class: container_class) do |node|
					items = container.each(options).sort do |a, b|
						if metadata[a.original.last]["order"] and metadata[b.original.last]["order"]
							metadata[a.original.last]["order"] <=> metadata[b.original.last]["order"]
						else
							a.original.last <=> b.original.last
						end
					end

					items.each do |path|
						next if filter and !filter.match(path.original.last)
				
						alt = Metadata.new(metadata[path.original.last])
						
						transaction.tag(tag_name, src: path, alt: alt)
					end
				end
			end
		end
	end
end
