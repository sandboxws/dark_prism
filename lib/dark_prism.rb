require 'active_support'
require 'active_support/core_ext'
require 'singleton'
require 'dark_prism/dispatch'
require 'dark_prism/dispatcher'
require 'dark_prism/version'

module DarkPrism
  class Config
    include Singleton
    attr_reader :dispatcher

    def initialize
      @dispatcher = DarkPrism::Dispatcher.instance
    end

    def self.configure(&block)
      raise NoBlockGivenException unless block_given?
      instance = Config.instance
      instance.instance_eval(&block)

      instance
    end

    def register_listeners(klass_mod)
      klass_mod.listeners.each do |event_name, listeners|
        dispatcher.add_listeners(event_name, listeners)
      end
    end
  end

  def self.configure(&block)
    raise NoBlockGivenException unless block_given?
    Config.configure(&block)
  end

  class NoBlockGivenException < Exception; end
end
