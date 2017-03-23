# Utopia::Gallery

This extension for [Utopia](https://github.com/ioquatix/utopia) provides tags for generating photo galleries. Works well in conjunction with [jQuery.LiteBox](https://github.com/ioquatix/jquery-litebox).

## Installation

Add this line to your website's Gemfile:

	gem 'utopia-gallery'

And then execute:

	$ bundle

## Usage

Require the tag in your `config/environment.rb`:

	require 'utopia/gallery'

In your `config.ru` add the `gallery` namespace:

use Utopia::Content,
	namespaces: {
		'gallery' => Utopia::Gallery::Tags.new
	}

In your `xnode`:

```html
<gallery:container path="_photos"/>
```

### Customizing Generated Markup

The best way to customize the output is to specify a tag to use:

```html
<gallery:container path="_photos" tag="content:photo"/>
```

Add `_photo.xnode` such as:

```html
<figure class="photo">
	<a href="#{attributes[:src].large}" title="#{attributes[:alt]}">
		<img src="#{attributes[:src].small}" alt="#{attributes[:alt]}"/>
	</a>
	<figcaption>#{attributes[:alt]}</figcaption>
</figure>
```

### Adding Captions

You can add captions and other metadata by adding a `gallery.yaml` file:

```yaml
bear.jpg:
  caption: "Brown bear is angry!"
  order: 1
```

This file needs to be placed in the same directory as the images, and metadata can be accessed via the `alt` attribute, e.g. `attributes[:alt]['caption']`.

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
