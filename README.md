SpreePurchasing
===============

Supplier Purchase Ordering for Spree

Installation
------------

Add spree_purchasing to your Gemfile:

```ruby
gem 'spree_purchasing', github: 'complistic-gaff/spree_purchasing'
```

Bundle your dependencies and run the installation generator:

```shell
bundle install
bundle exec rails g spree_purchasing:install
```

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

```shell
bundle
bundle exec rake test_app
bundle exec rspec spec
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_purchasing/factories'
```

Copyright (c) 2013 David Bennett, released under the New BSD License
