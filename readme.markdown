# pngnq

A Ruby wrapper around `pngnq`'s command-line interface.

## Installation

Add this line to your application's Gemfile:

    gem 'pngnq'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pngnq

**You must also have `pngnq` binaries installed and accessible on your path.**

## Usage

``` ruby
require 'pngnq'

Pngnq.convert('path/to/some/file.png')
# or
Pngnq.convert('path/to/some/file.png', :colors => 128, :speed => 3)
```

Also, [read the docs](http://www.rubydoc.info/github/kreeger/pngnq/Pngnq).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write some code, and some specs to go with it.
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new pull request.
