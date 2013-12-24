# MeteorMotion

Rubymotion Wrapper for communication with Meteor apps via DDP, with SRP authentication capabilities.

## Installation

If using Bundler, add to your application's Gemfile:

    gem 'meteor-motion'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install meteor-motion
    
And in your application's Rakefile add:

```ruby
require 'meteor-motion'
```

## Usage

### Initialization

Create a new MeteorMotion client and connect to your Meteor app:

```ruby
client = MeteorMotion::Client.new
client.connect('localhost', 3000)
```

By default, it will expand the hostname to ```http://hostname:port/websocket``` per the current Meteor specifications.

### Collections and subscriptions

In order to receive data, you need to first create a local collection to handle the data. You should add an observer to this collection, that will be called whenever the data in the collection is changed.

```ruby
def book_handler action, id
    # action - will be one of [:added, :changed, :removed]
    # id - the id of the element of the collection affected
end

books = client.add_collection('books')
books.add_observer( self.method(:book_handler) )
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request