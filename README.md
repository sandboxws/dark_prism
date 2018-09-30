# DarkPrism

Simple and straightforward event dispatching for ruby.

[![Build Status](https://travis-ci.com/sandboxws/dark_prism.svg?branch=master)](https://travis-ci.com/sandboxws/dark_prism)
[![Maintainability](https://api.codeclimate.com/v1/badges/5660cb7cfd7c184bf096/maintainability)](https://codeclimate.com/github/sandboxws/dark_prism/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/5660cb7cfd7c184bf096/test_coverage)](https://codeclimate.com/github/sandboxws/dark_prism/test_coverage)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dark_prism'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dark_prism

## Usage

### Configuration

Here is an example of a DarkPrism configuration file that can be placed under Rails' `initializers` directory.

```ruby
DarkPrism.configure do |config|
  config.register_listeners(Listeners::Base)
  config.gcloud do |gcloud_config|
    gcloud_config.project_id = gcloud_project_id
    gcloud_config.credentials = credentials
  end
end
```

`Listeners::Base` class example:
```ruby
module Listeners
  class Base
    def self.listeners
      {
        user_created: [Listeners::Users::Created.new]
      }.freeze
    end
  end
end

module Listeners
  module Users
    class Created
      include DarkPrism::Dispatch

      def user_created(user)
        dispatch_pubsub(:user_created, user)
      end
    end
  end
end

```

Once you've configured DarkPrism, dispatching events is quiet easy. First you need to include the `Dispatch` module as follows:

```ruby
include DarkPrism::Dispatch
```

Once it's included, you can dispatch events through one the following three methods:

### dispatch_event(event_name, obj)

This method dispatches an object asynchronously to all available listeners to the event.

Example:
```ruby
dispatch_event(:my_event, some_object)
```

### dispatch_pubsub(topic_name, message, attributes = nil)

This method dispatches an object synchronously to a google pubsub topic.

Example:
```ruby
dispatch_pubsub(:my_event, some_object, { foo: :bar })
```

### dispatch_pubsub_async(topic_name, message, attributes = nil)

This method dispatches an object asynchronously to a google pubsub topic.

Example:
```ruby
dispatch_pubsub_async(:my_event, some_object, { foo: :bar })
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sandboxws/dark_prism. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DarkPrism project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sandboxws/dark_prism/blob/master/CODE_OF_CONDUCT.md).
