# Utopia::Tags::Gallery

Utopia is a website generation framework which provides a robust set of tools
to build highly complex dynamic websites. It uses the filesystem heavily for
content and provides frameworks for interacting with files and directories as
structure representing the website.

This package includes a useful gallery component which can be used for
displaying thumbnails of images, documents and movies.

## Installation

Add this line to your website's Gemfile:

    gem 'utopia-tags-gallery'

And then execute:

    $ bundle

## Usage

Require the tag in your `config.ru`:

	require 'utopia/tags/gallery'

In your `xnode`:

	<gallery path="#{relative_path_to_images}" tag="#{name_of_tag_per_item}" process="#{process_to_apply_per_item}" />

For example, if you have `_circle.xnode`:

	<div class="circle thumbnail">
		<a class="thumbnail" href="#{attributes["src"].original}" title="#{attributes["alt"]}">
			<img src="#{attributes["src"].circle}" alt="#{attributes["alt"]}" />
		</a>
		<div class="caption">#{attributes["alt"]}</div>
	</div>

Then you can create a gallery:

	<page>	
		<gallery path="_images" tag="circle" process="circle" />
	</page>

If you want to add captions, you can create `_images/gallery.yaml`:

	bear.jpg:
	    caption: "Brown bear is angry!"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Released under the MIT license.

Copyright, 2012, by [Samuel G. D. Williams](http://www.codeotaku.com/samuel-williams).

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
