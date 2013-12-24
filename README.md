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

def error_handler code, reason, details
    # Handler for general connection errors, malformed messages and failed subscriptions
end

client.on_error( self.method(:error_handler) )
```

By default, it will expand the hostname to ```http://hostname:port/websocket``` per the current Meteor specifications.

### Collections and subscriptions

In order to receive data, you need to first create a local collection to handle the data. You should add an observer to this collection, that will be called whenever the data in the collection is changed.

```ruby
def collection_handler action, id
>>>>>>> efa51dd07f00ab376f04fe3f9c3ad7e47bfb49d6
    # action - will be one of [:added, :changed, :removed]
    # id - the id of the element of the collection affected
end

collection = client.add_collection('collection_name')
collection.add_observer( self.method(:collection_handler) )
```

To remove an observer, simply call ```collection.remove_observer( method )```. With a collection setup, you can subscribe/unsubscribe to data published on the server with:

```ruby
client.subscribe('subscription_name', params)
client.unsubscribe('subscription_name')
```

When there is data available, you can access objects on the collection:

```ruby
object = collection.find(id)
att1 = object['att1']
att2 = object['att2']
```

### Method calls

```ruby
def method_callback action, result
    # action - one of the following [:result, :updated, :error]
    # result - either the return value of the method (when action == :result) 
    #          or error details (when action == :error)
end

client.call('some_method_name', self.method(:method_callback), params)
```

### Authentication

Right now, MeteorMotion provides support for authentication using Meteor's built-in SRP. To authenticate with a username/password combination use the following:

```ruby
def login_handler action, details
    # action - either :success or :error
    # details - nil on :success, Hash with error details on :error 
end

client.login_with_username('username', 'password', self.method(:login_handler))
```

## Testing

To run tests first start-up the included sample Meteor app:

```bash
cd spec/server
meteor run
```

Then run the tests with rake:

```bash
rake spec
>>>>>>> efa51dd07f00ab376f04fe3f9c3ad7e47bfb49d6
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
