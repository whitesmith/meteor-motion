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
client.connect('localhost', 3000, self.method(:on_connect) )

def on_connect status
    # Handler for the connection attempt - optional
    # status - either true or false
end

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

### Model Adapters
Meteor-Motion supports, for the time being, and adapter to be used with the [MotionModel gem](https://github.com/sxross/MotionModel). After installing it, simply define your model classes as such:

```ruby
class Objects
    include MotionModel::Model
    include MotionModel::ArrayModelAdapter
    include MeteorMotion::Adapters::MotionModel

    columns :id, :string
    #...
end

client.add_collection(Objects, name='objects')

```

The ```id```column is mandatory, so that MeteorMotion does not auto-generate and id column with an integer type, which is incompatible with Meteor standard. Also, take care that if you ommit the ```name``` parameter when adding the collection, the collection name will default to the downcased name of your class. After this setup, enjoy MotionModel as usual.

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
```

### Example app

You can find a working example in the ```app``` directory. Remember to run the meteor server prior to starting the application. To login, use the credentials ```user/pass```. To run the application in the simulator simply run:

```bash
rake
```

## Credits
### Developed by
<a href="http://whitesmith.co/">
    <img src="http://www.whitesmith.co/assets/logo-whitesmith-4109176a79f86b9ca4b8022d6dcab3bb.png" alt="http://whitesmith.co/" height=100px />
</a>

Lead Developer: [mgontav](https://github.com/mgontav)

### Sponsored by
<a href="http://www.revokom.com/">
    <img src="http://www.revokom.com/img/logo_banner.png" alt="http://www.revokom.com/"/>
</a>



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
