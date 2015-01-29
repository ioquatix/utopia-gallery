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

require 'RMagick'

module Utopia
	module Tags
		module Gallery
			module Processes
				class Thumbnail
					def initialize(size = [800, 800])
						@size = size
					end
		
					def call(img)
						# Only resize an image if it is bigger than the given size.
						if (img.columns > @size[0] || img.rows > @size[1])
							img.resize_to_fit(*@size)
						else
							img
						end
					end
		
					def default_extension(path)
						ext = path.original.extension
						
						case ext
						when /pdf/i
							return "png"
						else
							return ext.downcase
						end
					end
				end
	
				# Resize the image to fit within the specified dimensions while retaining the aspect ratio of the original image. If necessary, crop the image in the larger dimension.
				class CropThumbnail < Thumbnail
					def call(img)
						img.resize_to_fill(*@size)
					end
				end
	
				class CircularCropThumbnail < CropThumbnail
					def call(img)
						img = super(img)

						# The crop composite doesn't work correcty with unusual colourspaces:
						img.colorspace = Magick::SRGBColorspace

						circle = Magick::Image.new(*@size)
						gc = Magick::Draw.new
						gc.fill('black')
						gc.circle(@size[0] / 2.0, @size[1] / 2.0, @size[0] / 2.0, 1)
						gc.draw(circle)

						mask = circle.blur_image(0,1).negate

						mask.matte = false
						img.matte = true

						img.composite!(mask, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)
					end
				end
	
				class DocumentThumbnail < Thumbnail
					def call(img)
						img = super(img)
			
						img.colorspace = Magick::SRGBColorspace
			
						return img
					end
		
					def default_extension(path)
						return "png"
					end
				end

				class PhotoThumbnail < Thumbnail
					def default_extension(path)
						return "jpeg"
					end
				end
			
				DEFAULT = {
					:document => Processes::DocumentThumbnail.new([300, 300]),
					:photo => Processes::PhotoThumbnail.new([300, 300]),

					:square => Processes::CropThumbnail.new([300, 300]),
					:circle => Processes::CircularCropThumbnail.new([300, 300]),

					:large => Processes::Thumbnail.new([800, 800]),
					:small => Processes::Thumbnail.new([300, 300]),
				}
			end
		end
	end
end
