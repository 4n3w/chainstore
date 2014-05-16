require 'bundler/setup'
Bundler.setup

require 'chainstore'
#require 'chainstore/exceptions'
#require 'chainstore/stores/in_memory_naive_store'
#require 'chainstore/stores/lru_memory_store'
#require 'chainstore/stores/s3_store'
#require 'chainstore/stores/redis_store'

RSpec.configure { |config|
  config.order = 'random'
}