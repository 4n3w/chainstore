require 'bundler/setup'
Bundler.setup

require 'chainstore'

RSpec.configure { |config|
  config.order = 'random'
}