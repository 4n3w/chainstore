# Chainstore

A simple Chain of Responsibility to manage storing tuples in a chained set of storage services.

lru = LRU_MemoryStore.new 16
redis = RedisStore.new
s3 = S3Store.new 'AKIAI2BCDKXTOHL7PM4A', 'z3xfZdRn+bqixtcxZZKJTwtPQ/bGcNTLxm+ZOzC9', 's3.amazonaws.com', 'testing-chainstore-pressly' }

chain = Chainstore::Chain.new lru, redis, s3

chain.put 'Secret of the Universe', '42'


## Installation

Add this line to your application's Gemfile:

    gem 'chainstore'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chainstore

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/4n3w/chainstore/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
