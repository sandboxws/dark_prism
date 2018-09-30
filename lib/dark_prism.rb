require 'active_support'
require 'active_support/core_ext'
require 'singleton'
require 'dark_prism/config/main_config'
require 'dark_prism/dispatch'
require 'dark_prism/dispatcher'
require 'dark_prism/version'

module DarkPrism
  def self.configure(&block)
    raise NoBlockGivenException unless block_given?

    Config::MainConfig.configure(&block)
  end

  class NoBlockGivenException < RuntimeError; end
end
