require 'simplecov'
require 'simplecov-console'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::Console
]
SimpleCov.start do
  add_filter(/spec/)
end

require 'bundler/setup'
Bundler.setup

require 'pry'
require 'support/common'
require 'active_support'
require 'google/cloud/pubsub'
require 'dark_prism'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

RSpec::Matchers.define :have_attr_accessor do |attribute|
  match do |object|
    object.respond_to?(attribute) && object.respond_to?("#{attribute}=")
  end

  description do
    "have attr_writer :#{attribute}"
  end
end

RSpec::Matchers.define :have_attr_reader do |attribute|
  match do |object|
    object.respond_to? attribute
  end

  description do
    "have attr_reader :#{attribute}"
  end
end

RSpec::Matchers.define :have_attr_writer do |attribute|
  match do |object|
    object.respond_to? "#{attribute}="
  end

  description do
    "have attr_writer :#{attribute}"
  end
end
